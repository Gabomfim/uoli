#include <stdio.h>
#include <stdlib.h>
#include "api_robot2.h"
void debug();

int main(int argc, char** argv){
    while(1){
        int a1 = get_us_distance();
        if(a1 == -1){
            puts("F");
        }else{
            puts("T");
        }
    }
    return 0;
}