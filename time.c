#ifdef CS333_P2
#include "types.h"
#include "user.h"
int
main(int argc, char* argv[])
{
  int run_time;
  int start;
  int millisec;
  
  //No program to time
  if(argc < 2) {
    start = uptime();
    printf(1, "%s ran in ", argv[1]);
    run_time = uptime() - start;
    millisec = run_time % 1000;
    run_time = run_time/1000;
    printf(1, "%d.", run_time);

    if (millisec < 10)
      printf(1, "00");
    else if (millisec < 100 && millisec >= 10)
      printf(1, "0");  

    printf(1, "%d seconds.\n", millisec);
  }
  //There is a program to time
  else {
    start = uptime();
    int pid;

    pid = fork();
    //Fork error - show error message
    if (pid < 0) {
      printf(2, "Fork error\n");
      exit();
    }
    //If child, call exec and check for error
    else if (pid == 0) {
      if(exec(argv[1], &argv[1]) < 0) {
        printf(2, "Exec error\n");
        exit();
      }
    }
    //Parent process - wait for child, display time
    else {
      wait();
      printf(1, "%s ran in ", argv[1]);
      run_time = uptime() - start;
      millisec = run_time % 1000;
      run_time = run_time/1000;
      printf(1, "%d.", run_time);
      if (millisec < 10)
        printf(1, "00");
      else if (millisec < 100 && millisec >= 10)
        printf(1, "0");  

      printf(1, "%d seconds.\n", millisec);
    }
  }

  exit();
}

#endif
