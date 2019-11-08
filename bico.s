.globl set_torque
.globl set_engine_torque
.globl set_head_servo
.globl get_us_distance
.globl get_current_GPS_position
.globl get_gyro_angles
.globl get_time
.globl set_time
.globl puts
.globl read_ultrasonic_sensor
.globl set_servo_angles
.globl read_gps
.globl read_gyroscope
.globl write 

    read_ultrasonic_sensor:
      li a7, 16 #call read_ultrasonic_sensor
      ecall
      j exit
    set_servo_angles:
      li a7, 17 #call set_servo_angles
      ecall
      j exit
    set_torque:
    set_engine_torque:
      li a7, 18 #call set_engine_torque
      ecall
      j exit
    read_gps:
      li a7, 19 #call read_gps
      ecall
      j exit
    read_gyroscope:
      li a7, 20 #call read_gyroscope
      ecall
      j exit
    get_time:
      li a7, 21 #call get_time
      ecall
      j exit
    set_time:
      li a7, 22 #call set_time
      ecall
      j exit
    write:
      li a7, 64 #call write
      ecall
      j exit

exit:
    li a0, 0 # exit code
    li a7, 93 # syscall exit
    ecall
