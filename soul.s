  _start:
# Configura o tratador de interrupções
la t0, int_handler # Grava o endereço do rótulo int_handler
csrw mtvec, t0 # no registrador mtvec
# Habilita Interrupções Global
csrr t1, mstatus # Seta o bit 3 (MIE)
ori t1, t1, 0x80 # do registrador mstatus
csrw mstatus, t1
# Habilita Interrupções Externas
csrr t1, mie # Seta o bit 11 (MEIE)
li t2, 0x800 # do registrador mie
or t1, t1, t2
csrw mie, t1
# Ajusta o mscratch
la t1, reg_buffer # Coloca o endereço do buffer para salvar
csrw mscratch, t1 # registradores em mscratch
li sp, 134217724#seta o endereço da pilha
 
# Muda para o Modo de usuário
csrr t1, mstatus # Seta os bits 11 e 12 (MPP)
li t2, ~0x1800 # do registrador mstatus
and t1, t1, t2 # com o valor 00
csrw mstatus, t1
la t0, user # Grava o endereço do rótulo user
csrw mepc, t0 # no registrador mepc
mret # PC <= MEPC; MIE <= MPIE; Muda modo para MPP

int_handler:
    li t1, 16
    beq a7, t1, read_ultrasonic_sensor
    li t1, 17
    beq a7, t1, set_servo_angles
    li t1, 18
    beq a7, t1, set_engine_torque
    li t1, 19
    beq a7, t1, read_gps
    li t1, 20
    beq a7, t1, read_gyroscope
    li t1, 21
    beq a7, t1, get_time
    li t1, 22
    beq a7, t1, set_time
    li t1, 64
    beq a7, t1, write
    
    read_ultrasonic_sensor:
    set_servo_angles:
    set_engine_torque:
    read_gps:
    read_gyroscope:
    get_time:
    set_time:
    write:
