#include "api_robot2.h"
void debug();

int main(int argc, char** argv){

    Vector3 meuRobo;
    set_torque(-10,10);
    while(1){
    
    get_gyro_angles(&meuRobo);
    int x = meuRobo.x;
    int y = meuRobo.y;
    int z = meuRobo.z;
    }
}
