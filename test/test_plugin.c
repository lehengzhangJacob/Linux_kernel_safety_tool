int global_var;
int protected_var;

// Mock kernel lock functions
void spin_lock(void *lock) {}
void spin_unlock(void *lock) {}

// Wrapper functions (Inter-procedural test)
void my_lock(void *lock) {
    spin_lock(lock);
}

void my_unlock(void *lock) {
    spin_unlock(lock);
}

void func(void) {
    int local_var = 0;
    
    // Unprotected Write -> Should trigger RACE_WARNING
    global_var = 1; 
}

void protected_func(void) {
    int lock = 0;
    
    // Protected Write via Wrappers -> Should NOT trigger RACE_WARNING
    my_lock(&lock);
    protected_var = 1;
    my_unlock(&lock);
    
    // Unprotected Read -> Should trigger RACE_WARNING
    int x = protected_var;
}
