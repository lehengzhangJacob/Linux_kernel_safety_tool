#include <stdio.h>

// Global variable
int global_counter = 0;
static int static_var = 10;

void increment_counter() {
    global_counter++;
}

void read_counter() {
    printf("Counter: %d\n", global_counter);
}

void process_data() {
    static_var++;
    increment_counter();
    read_counter();
}

int main() {
    process_data();
    return 0;
}
