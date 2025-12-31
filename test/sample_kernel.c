#include <linux/module.h>
#include <linux/kernel.h>

/* Global Variables */
int global_counter = 0;
struct task_struct *current_task;
unsigned long flags;

/* Function Prototypes */
void increment_counter(void);
void read_task(void);

/* Function Definitions */
void increment_counter(void) {
    // Write access
    global_counter++;
    global_counter = global_counter + 10;
}

void read_task(void) {
    struct task_struct *t;
    // Read access
    t = current_task;
    
    // Read access
    if (global_counter > 100) {
        printk("Counter is high\n");
    }
}

int complex_access(void) {
    // Read and Write
    flags = 0;
    return global_counter;
}
