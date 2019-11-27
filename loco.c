#include <stdio.h>
#include <stdlib.h>
#include "api_robot2.h"

int main(int argc, char** argv){
    while(1){
        if(get_us_distance() == -1){
            puts("F");
        }else{
            puts("T");
        }
    }
    return 0;
}