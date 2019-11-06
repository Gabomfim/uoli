.globl set_torque
.globl set_engine_torque
.globl set_head_servo
.globl get_us_distance
.globl get_current_GPS_position
.globl get_gyro_angles
.globl get_time
.globl set_time
.globl puts

    read_ultrasonic_sensor:
      j exit
    set_servo_angles:
      j exit
    set_torque:
    set_engine_torque:
      li a7, 18 #call set_engine_torque
      ecall
      j exit
    read_gps:
      j exit
    read_gyroscope:
      j exit
    get_time:
      j exit
    set_time:
      j exit
    write:
      j exit

exit:
    li a0, 0 # exit code
    li a7, 93 # syscall exit
    ecall
