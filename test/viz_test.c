int global_var = 0;
int another_var = 1;

void func_c() {
    global_var++;
}

void func_b() {
    func_c();
    int x = another_var;
}

void func_a() {
    func_b();
    global_var = 10;
}
