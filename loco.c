#include <stdio.h>
#include <stdlib.h>
#include "api_robot2.h"

int main(int argc, char** argv){
    set_torque(2, 2);
    read_ultrasonic_sensor();
    return 0;
}
