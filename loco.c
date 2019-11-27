#include "api_robot2.h"
void debug();

int main(int argc, char** argv){
    Vector3 meuRobo;
    int x;
    int y;
    int z;
    while(1){
        get_gyro_angles(&meuRobo);
        x = meuRobo.x;
        y = meuRobo.y;
        z = meuRobo.z;

    }
}
