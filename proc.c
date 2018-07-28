#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "uproc.h"

#ifdef CS333_P3P4
struct state_lists {
  struct proc* ready;
  struct proc* ready_tail;
  struct proc* free;
  struct proc* free_tail;
  struct proc* sleep;
  struct proc* sleep_tail;
  struct proc* zombie;
  struct proc* zombie_tail;
  struct proc* running;
  struct proc* running_tail;
  struct proc* embryo;
  struct proc* embryo_tail;
};
#endif

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  #ifdef CS333_P3P4
  struct state_lists pLists;
  #endif
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);


#ifdef CS333_P3P4
static void initProcessLists(void);
static void initFreeList(void);
// __attribute__ ((unused)) suppresses warnings for routines that are not
// currently used but will be used later in the project. This is a necessary
// side-effect of using -Werror in the Makefile.
static void __attribute__ ((unused)) stateListAdd(struct proc** head, struct proc** tail, struct proc* p);
static void __attribute__ ((unused)) stateListAddAtHead(struct proc** head, struct proc** tail, struct proc* p);
static int __attribute__ ((unused)) stateListRemove(struct proc** head, struct proc** tail, struct proc* p);
static void assertState(struct proc* p, enum proc state);
#endif

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  
  //For P3P4 - check free list
  #ifdef CS333_P3P4
  if(ptable.pLists.free)
    p = ptable.pLists.free;
    goto found;
     
  #else
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  #endif

  release(&ptable.lock);
  return 0;

 found:
  #ifdef CS333_P3P4
  //Panics kernel if error in removing process from free list, proceeds otherwise to add to embryo list
  //1st remove from old list, then assert state, update state, and last add to new state list
  int rc = stateListRemove(&ptable.pLists.free, &ptable.pLists.free_tail, p);
  if (rc < 0)
    panic("Failure in stateListRemove from free list - allocproc()\n");
  assertState(p, UNUSED);
  p->state = EMBRYO;
  stateListAdd(&ptable.pLists.embryo, &ptable.pLists.embryo_tail, p);
  
  #else
  p->state = EMBRYO;
  #endif

  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    //If error in allocation, remove from embryo and revert to free list
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
    int rc = stateListRemove(&ptable.pLists.embryo, &ptable.pLists.embryo_tail, p);
    if (rc < 0)
      panic("Failure in stateListRemove from embryo list - allocproc()\n");
    assertState(p, EMBRYO);
    p->state = UNSUSED;
    stateListAdd(&ptable.pLists.free, &ptable.pLists.free_tail, p);
    release(&ptable.lock);

    #else
    p->state = UNUSED;
    #endif

    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  //P1 - ctrl-p
  #ifdef CS333_P1
  p->start_ticks = ticks;
  #endif
  //P2 - CPU time tracking
  #ifdef CS333_P2
  p->cpu_ticks_total = 0;
  p->cpu_ticks_in = 0;
  #endif

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  //P3 - state lists - Call initialization functions
  #ifdef CS333_P3P4
  acquire(&ptable.lock);
  initProcessLists();
  initFreeList();
  release(&ptable.lock);
  #endif 

  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  //P3 - embryo->ready transition
  #ifdef CS333_P3P4
  acquire(&ptable.lock);
  int rc = stateListRemove(&ptable.pLists.embryo, &ptable.pLists.embryo_tail, p);
  if (rc < 0)
    panic("Failure in stateListRemove from embryo list - userinit()\n");
  assertState(p, EMBRYO);
  p->state = RUNNABLE;
  stateListAdd(&ptable.pLists.ready, &ptable.pLists.ready_tail, p);
  release(&ptable.lock);

  #else
  p->state = RUNNABLE;
  #endif

  //P2 - UID, GID
  #ifdef CS333_P2
  p->uid = DEFUID;
  p->gid = DEFGID;
  #endif
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;

    //P3 - embryo->free transition
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
    int rc = stateListRemove(&ptable.pLists.embryo, &ptable.pLists.embryo_tail, np);
    if (rc < 0)
      panic("Failure in stateListRemove from embryo list - fork()\n");
    assertState(np, EMBRYO);
    np->state = UNUSED;
    stateListAdd(&ptable.pLists.free, &ptable.pLists.free_tail, np);
    release(&ptable.lock);

    #else
    np->state = UNUSED;
    #endif

    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;
  //P2 - UID, GID
  #ifdef CS333_P2
  np->uid = proc->uid;
  np->gid = proc->gid;
  #endif

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));

  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);

  //P3 - embryo->ready transition
  #ifdef CS333_P3P4
  int rc = stateListRemove(&ptable.pLists.embryo, &ptable.pLists.embryo_tail, np);
  if (rc < 0)
    panic("Failure in stateListRemove from embryo list - fork()\n");
  assertState(np, EMBRYO);
  np->state = RUNNABLE;
  stateListAdd(&ptable.pLists.ready, &ptable.pLists.ready_tail, np);

  #else
  np->state = RUNNABLE;
  #endif

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

#else
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // P3 - Search ready, running, sleep, & zombie lists for abandoned
  // children and pass to init if exiting process is parent.

  //Ready list search
  p = ptable.pLists.ready;
  while(p) {
    if(p->parent == proc) 
      p->parent = initproc;
    p = p->next;    //Traverse through list
  }

  //Running list search
  p = ptable.pLists.running;
  while(p) {
    if(p->parent == proc) 
      p->parent = initproc;
    p = p->next;    //Traverse through list
  }

  //Sleep list search
  p = ptable.pLists.sleep;
  while(p) {
    if(p->parent == proc) 
      p->parent = initproc;
    p = p->next;    //Traverse through list
  }

  //Zombie list search
  p = ptable.pLists.zombie;
  while(p) {
    if(p->parent == proc) {
      p->parent = initproc;
      wakeup1(initproc);    //Wakeup parent
    }
    p = p->next;    //Traverse through list
  }

  // Jump into the scheduler, never to return.
  //P3 - running->zombie transition
  int rc = stateListRemove(&ptable.pLists.running, &ptable.pLists.running_tail, proc);
  if (rc < 0)
    panic("Failure in stateListRemove from running list - exit()\n");
  assertState(proc, RUNNING);
  proc->state = ZOMBIE;
  stateListAdd(&ptable.pLists.zombie, &ptable.pLists.zombie_tail, proc);

  sched();
  panic("zombie exit");
}
#endif

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#else
int
wait(void)
{

  return 0;  // placeholder
}
#endif

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      #ifdef CS333_P2
      p->cpu_ticks_in = ticks;
      #endif
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}

#else
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process

    // If ready list is not empty, run scheduler in RR
    acquire(&ptable.lock);

    p = ptable.pLists.ready;
    if(p){
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      int rc = stateListRemove(&ptable.pLists.ready, &ptable.pLists.ready_tail, p);
      if (rc < 0)
        panic("Failure in stateListRemove from ready list - scheduler()\n");
      assertState(p, RUNNABLE);
      p->state = RUNNING;
      stateListAdd(&ptable.pLists.running, &ptable.pLists.running_tail, p);
      #ifdef CS333_P2
      p->cpu_ticks_in = ticks;
      #endif
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}
#endif

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  //P2 - CPU time tracking
  #ifdef CS333_P2
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in;
  #endif
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock

  //P3 - running->ready
  #ifdef CS333_P3P4
  int rc = stateListRemove(&ptable.pLists.running, &ptable.pLists.running_tail, proc);
  if (rc < 0)
    panic("Failure in stateListRemove from running list - yield()\n");
  assertState(proc, RUNNING);
  proc->state = RUNNABLE;
  stateListAdd(&ptable.pLists.ready, &ptable.pLists.ready_tail, proc);

  #else
  proc->state = RUNNABLE;
  #endif

  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
    acquire(&ptable.lock);
    if (lk) release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  proc->state = SLEEPING;
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}

//PAGEBREAK!
#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
  //P3 - traverse through sleep list, if chan matches: sleeping->ready transition
  struct proc *p;
  p = ptable.pLists.sleep;

  while(p){
    if(p->chan == chan){
      acquire(&ptable.lock);
      int rc = stateListRemove(&ptable.pLists.sleep, &ptable.pLists.sleep_tail, p);
      if (rc < 0)
        panic("Failure in stateListRemove from running list - wakeup1()\n");
      assertState(p, SLEEPING);
      p->state = RUNNABLE;
      stateListAdd(&ptable.pLists.ready, &ptable.pLists.ready_tail, p);
      release(&ptable.lock);
    }
    p = p->next;
  }
}
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#else
int
kill(int pid)
{

  return 0;  // placeholder
}
#endif

static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
};

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  #ifdef CS333_P2
  cprintf("\nPID\tName\t\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\t PCs\n");
  #elif CS333_P1
  cprintf("\nPID\tState\tName\tElapsed\t PCs\n");
  #endif

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
	  
    //P2 - ctrl-p print UID, GID, PPID
	  #ifdef CS333_P2
    int ppid;
    int elapsed;
    int millisec;
    int cpu_millisec;
    int cpu;

    if(p->parent)
      ppid = p->parent->pid;
    else
      ppid = p->pid;
    elapsed = ticks - p->start_ticks;
    millisec = elapsed % 1000;
    elapsed = elapsed/1000;
    cpu = p->cpu_ticks_total;
    cpu_millisec = cpu % 1000;
    cpu = cpu/1000;

    cprintf("%d\t%s\t", p->pid, p->name);
    if (strlen(p->name) < 7)    //Ensures column spacing is aligned for longer names
      cprintf("\t");
    cprintf("%d\t%d\t%d\t%d.", p->uid, p->gid, ppid, elapsed);

	  if (millisec < 10)
      cprintf("00");
    else if (millisec < 100 && millisec >= 10)
      cprintf("0");  
	  cprintf("%d\t%d.", millisec, cpu);
   
	  if (cpu_millisec < 10)
      cprintf("00");
    else if (cpu_millisec < 100 && cpu_millisec >= 10)
      cprintf("0");  
	  cprintf("%d\t%s\t%d\t", cpu_millisec, state, p->sz,"\n");
	  
    //P1 - ctrl-p print
	  #elif CS333_P1
    int elapsed;
    int millisec;
    
    elapsed = ticks - p->start_ticks;
    millisec = elapsed % 1000;
    elapsed = elapsed/1000;

    cprintf("%d\t%s\t%s\t%d.", p->pid, state, p->name, elapsed);

  	if (millisec < 10)
      cprintf("00");
    else if (millisec < 100 && millisec >= 10)
      cprintf("0");  
	  cprintf("%d\t", millisec,"\n");
    
    #else
    cprintf("%d %s %s", p->pid, state, p->name);
  	#endif

    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}


#ifdef CS333_P3P4
static void
stateListAdd(struct proc** head, struct proc** tail, struct proc* p)
{
  if(*head == 0){
    *head = p;
    *tail = p;
    p->next = 0;
  } else{
    (*tail)->next = p;
    *tail = (*tail)->next;
    (*tail)->next = 0;
  }
}

static void
stateListAddAtHead(struct proc** head, struct proc** tail, struct proc* p)
{
  if(*head == 0){
    *head = p;
    *tail = p;
    p->next = 0;
  } else {
    p->next = *head;
    *head = p;
  }
}

static int
stateListRemove(struct proc** head, struct proc** tail, struct proc* p)
{
  if(*head == 0 || *tail == 0 || p == 0){
    return -1;
  }

  struct proc* current = *head;
  struct proc* previous = 0;

  if(current == p){
    *head = (*head)->next;
    // prevent tail remaining assigned when we've removed the only item
    // on the list
    if(*tail == p){
      *tail = 0;
    }
    return 0;
  }

  while(current){
    if(current == p){
      break;
    }

    previous = current;
    current = current->next;
  }

  // Process not found, hit eject.
  if(current == 0){
    return -1;
  }

  // Process found. Set the appropriate next pointer.
  if(current == *tail){
    *tail = previous;
    (*tail)->next = 0;
  } else{
    previous->next = current->next;
  }

  // Make sure p->next doesn't point into the list.
  p->next = 0;

  return 0;
}

static void
initProcessLists(void)
{
  ptable.pLists.ready = 0;
  ptable.pLists.ready_tail = 0;
  ptable.pLists.free = 0;
  ptable.pLists.free_tail = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.sleep_tail = 0;
  ptable.pLists.zombie = 0;
  ptable.pLists.zombie_tail = 0;
  ptable.pLists.running = 0;
  ptable.pLists.running_tail = 0;
  ptable.pLists.embryo = 0;
  ptable.pLists.embryo_tail = 0;
}

static void
initFreeList(void)
{
  if(!holding(&ptable.lock)){
    panic("acquire the ptable lock before calling initFreeList\n");
  }

  struct proc* p;

  for(p = ptable.proc; p < ptable.proc + NPROC; ++p){
    p->state = UNUSED;
    stateListAdd(&ptable.pLists.free, &ptable.pLists.free_tail, p);
  }
}

static void 
assertState(struct proc* p, enum proc state)
{
  if(p->state != state) {
    cprintf("Failure in assertState. p->state is %s instead of %s", states[p->state], states[state]);
    panic("Kernel panic\n");
  }
}

#endif

#ifdef CS333_P2
int 
getprocs(uint max, struct uproc * table)
{
  struct proc * p;
  int count;

  count = 0;
  p = ptable.proc;

  acquire(&ptable.lock);
  while(p < &ptable.proc[NPROC] && count < max) {
    if(p->state != UNUSED && p->state != EMBRYO) {
      ++count;
      table->pid = p->pid;
      table->uid = p->uid;
      table->gid = p->gid;
      if(p->parent)
        table->ppid = p->parent->pid;
      else
        table->ppid = p->pid;
      table->elapsed_ticks = ticks - p->start_ticks;
      table->CPU_total_ticks = p->cpu_ticks_total;
      safestrcpy(table->state, states[p->state], STRMAX);
      table->size = p->sz;
      safestrcpy(table->name, p->name, STRMAX);
      ++table;
    }
    ++p;
  }
  release(&ptable.lock);

  return count;
}
#endif
