#ifdef CS333_P2
#include "types.h"
#include "user.h"
#include "uproc.h"

int
main(void)
{
  uint max = 16;
  struct uproc* table;
  int count;
  int elapsed;
  int millisec;
  int cpu;
  int cpu_millisec;

  table = malloc(sizeof(struct uproc) * max);
  count = getprocs(max, table);

  if(count < 0)
    printf(2, "There was an error in creating the user process table\n");
  else {
    printf(1, "\nPID\tName\t\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");

    for(int i = 0; i < count; ++i) {
      elapsed = table[i].elapsed_ticks;
      millisec = elapsed % 1000;
      elapsed = elapsed/1000;
      cpu = table[i].CPU_total_ticks;
      cpu_millisec = cpu % 1000;
      cpu = cpu/1000;

      printf(1, "%d\t%s\t", table[i].pid, table[i].name);
      if (strlen(table[i].name) < 7)  //Ensures columns are aligned for long names
        printf(1,"\t");
      printf(1, "%d\t%d\t%d\t%d.", table[i].uid, table[i].gid, table[i].ppid, elapsed);
      if (millisec < 10)
        printf(1, "00");
      else if (millisec < 100 && millisec >= 10)
        printf(1, "0");  
      printf(1, "%d\t%d.", millisec, cpu);
                  
      if (cpu_millisec == 0)
        printf(1, "000");
      else if (cpu_millisec < 10 && cpu_millisec > 0)
        printf(1, "00");
      else if (cpu_millisec < 100 && cpu_millisec >= 10)
        printf(1, "0");  
      printf(1, "%d\t%s\t%d\n", cpu_millisec, table[i].state, table[i].size);
    }
  }

  free(table);
  exit();
}
#endif
