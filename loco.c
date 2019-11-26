#include <stdio.h>
#include <stdlib.h>
#include "api_robot2.h"

int main(int argc, char** argv){
    while(1){
        set_head_servo(0, 16); //base
        set_head_servo(1, 52); //mid
        set_head_servo(2, 0); //top
        set_head_servo(0, 116); //base
        set_head_servo(1, 90); //mid
        set_head_servo(2, 156); //top
    }
    return 0;
}