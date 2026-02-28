#include <linux/module.h>
#include <linux/kernel.h>

// 全局变量
int global_counter = 0;
char global_buffer[100];

// 函数定义
void increment_counter(void) {
    global_counter++;
}

void write_buffer(const char *data) {
    strcpy(global_buffer, data);
}

int read_counter(void) {
    return global_counter;
}

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Test");
MODULE_DESCRIPTION("Test module for kernel analysis");