//uproc struct holds limited fields from proc struct to be used with ps command
#define STRMAX 32

// Process info for ps command
struct uproc {
  uint pid;                    // Process ID
  uint uid;                    // Process User ID
  uint gid;                    // Process Group ID
  uint ppid;                   // Parent process' ID
  uint elapsed_ticks;          // Time since process started
  uint CPU_total_ticks;        // Total elapsed ticks in CPU
  char sate[STRMAX];           // Process state
  uint size;                   // Size of process memory (bytes)
  char name[STRMAX];           // Process name
};

