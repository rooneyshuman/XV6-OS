#ifdef CS333_P5
#include "types.h"
#include "user.h"
int
main(int argc, char * argv[])
{
  //arg count is not 3, error
  if(argc != 3) {
    printf(2, "Error - wrong number of arguments. Usage: chown OWNER TARGET \n");
    exit();
  }
  
  int rc = chown(argv[2], atoi(argv[1]));
  if(rc < 0)
    printf(2, "Error - wrong pathname or UID value \n");

  exit(); 
}

#endif
