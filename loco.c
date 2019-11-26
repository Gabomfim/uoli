#include <stdio.h>
#include <stdlib.h>
#include "api_robot2.h"

int main(int argc, char** argv){
    set_torque(20,20);
    set_torque(-20,-20);
    debug();
    return 0;
}

void debug(){
    int i;
    i = 1 + 2;
}