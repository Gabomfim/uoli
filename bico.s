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
.globl set_head_servo
.globl read_gps
.globl read_gyroscope

    read_ultrasonic_sensor:
      li a7, 16 #call read_ultrasonic_sensor
      ecall
      ret

    /* 
    * Sets the angle of three Servo motors that control the robot head. 
    *   Servo ID 0/1/2 identifies the Base/Mid/Top servos.
    * Parameter: 
    *   servo_id: Servo ID 
    *   angle: Servo Angle 
    * Returns:
    *   -1 in case the servo id is invalid
    *   -2 in case the servo angle is invalid
    *    0 in case the servo id and the angle is valid
    */
    set_head_servo:
      #eu assumi que os angulos e motores são válidos, precisa fazer esse check
      li a7, 17 #call set_servo_angles
      ecall
      ret

    set_torque:
      li a7, 18 #call set_engine_torque
      add t0, a1, 0 #coloca o valor do torque do motor 2 em t0
      add a1, a0, 0 #coloca o valor do torque do motor 1 em a1
      li a0, 0 #coloca o valor 0 em a0 (id motor 1)
      ecall
      li a0, 1 #coloca o valor 1 em a0 (id motor 2)
      add a1, t0, 0 #coloca o valor do torque do motor 2 em a1
      ecall
      ret

    set_engine_torque:
      li a7, 18 #call set_engine_torque
      ecall
      ret

    read_gps:
      li a7, 19 #call read_gps
      ecall
      ret

    read_gyroscope:
      li a7, 20 #call read_gyroscope
      ecall
      ret

    get_time:
      li a7, 21 #call get_time
      ecall
      ret

    set_time:
      li a7, 22 #call set_time
      ecall
      ret

# ==== Puts: tem que criar os três parâmetros do write ====
    puts:
      li t0, 0 #contador de número de char
      mv a1, a0 #a1 é o endereço pro vetor de char
      conta_char:
        add t2, a0, t0
        lw t3, 0(t2)
        beq t3, zero, continua
        addi t0, t0, 1
        j conta_char
      continua:
        mv a2, t0 #número de bytes a ser transmitido      
      li a7, 64 #call write
      ecall
      ret

