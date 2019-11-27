.globl set_torque
.globl set_engine_torque
.globl set_head_servo
.globl get_us_distance
.globl get_time
.globl set_time
.globl puts
.globl get_current_GPS_position
.globl get_gyro_angles

    get_us_distance:
      li a7, 16 #call read_ultrasonic_sensor
      ecall
      ret

    set_head_servo:
      li t0, 0
      beq a0, t0, set_head_servo_base
      li t0, 1
      beq a0, t0, set_head_servo_mid
      li t0, 2
      beq a0, t0, set_head_servo_top
      j set_head_servo_invalido

      #verifica erros no angulo
      set_head_servo_base:
        li t0, 16
        li t1, 116
        blt a1, t0, set_head_servo_angulo_invalido
        blt t1, a1, set_head_servo_angulo_invalido
        j set_head_servo_certo

      set_head_servo_mid:
        li t0, 52
        li t1, 90
        blt a1, t0, set_head_servo_angulo_invalido
        blt t1, a1, set_head_servo_angulo_invalido
        j set_head_servo_certo
      
      set_head_servo_top:
        li t0, 0
        li t1, 156
        blt a1, t0, set_head_servo_angulo_invalido
        blt t1, a1, set_head_servo_angulo_invalido
        j set_head_servo_certo

      set_head_servo_certo:
        li a7, 17 #call set_servo_angles
        ecall
        li a0, 0
        ret
      
      set_head_servo_invalido:
        li a0, -1
        ret

      set_head_servo_angulo_invalido:
        li a0, -2
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

    get_current_GPS_position:
      li a7, 19 #call read_gps
      ecall
      ret

    get_gyro_angles:
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
      conta_char: #conta número de caracteres da string
        add t2, a0, t0
        lb t3, 0(t2)
        beq t3, zero, continua
        addi t0, t0, 1
        j conta_char
      continua:
        mv a2, t0 #número de bytes a ser transmitido      
      li a7, 64 #call write
      ecall
      ret

