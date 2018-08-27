#ifdef CS333_P5
#include "types.h"
#include "user.h"
int
main(int argc, char * argv[])
{
  //arg count is not 3, error
  if(argc != 3) {
    printf(2, "Error - wrong number of arguments. Usage: chgrp GROUP TARGET \n");
    exit();
  }
  
  int rc = chgrp(argv[2], atoi(argv[1]));
  if(rc < 0)
    printf(2, "Error - wrong pathname or GID value \n");

  exit();
}

#endif
