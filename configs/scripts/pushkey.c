#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    if (argc != 2) return 1;
    char c = argv[1][0];
    ioctl(0, TIOCSTI, &c);
    return 0;
}