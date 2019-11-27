#include "api_robot2.h"
void debug();

int main(int argc, char** argv){
    Vector3 meuRobo;
    int x;
    int y;
    int z;
    while(1){
        get_current_GPS_position(&meuRobo);
        x = meuRobo.x;
        y = meuRobo.y;
        z = meuRobo.z;

    }
}
