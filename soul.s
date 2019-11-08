_start:
# Configura o tratador de interrupções
la t0, int_handler # Grava o endereço do rótulo int_handler
csrw mtvec, t0 # no registrador mtvec
# Habilita Interrupções Global
csrr t1, mstatus # Seta o bit 3 (MIE)
ori t1, t1, 0x80 # do registrador mstatus
csrw mstatus, t1
# Habilita Interrupções Externas
csrr t1, mie # Seta o bit 11 (MIE)
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

reg_buffer:

user:
  
int_handler:
    #salva o contexto

    csrrw a0, mscratch, a0 # troca valor de a0 com mscratch
    sw a1, 0(a0) # salva a1 
    sw a2, 4(a0) # salva a2 
    sw a3, 8(a0) # salva a3 
    sw a4, 12(a0) # salva a4
    sw a5, 16(a0)
    sw a6, 20(a0)
    sw a7, 24(a0)

    #trata interrupções
    li t1, 16
    beq a7, t1, ultrassonic
    li t1, 17
    beq a7, t1, servo
    li t1, 18
    beq a7, t1, engine
    li t1, 19
    beq a7, t1, gps
    li t1, 20
    beq a7, t1, gyroscope
    li t1, 21
    beq a7, t1, g_time
    li t1, 22
    beq a7, t1, s_time
    li t1, 64
    beq a7, t1, w
    
    ultrassonic:
    servo:
    engine: #18
      #teste de torque do motor 1
      beq a0, 0, motor1
      beq a0, 1, motor2
      motor1:
      li t0, 0xFFFF001A
      sw a1, 0(t0) #coloca o valor de a1(argumento) no torque do motor 1
      motor2:
      li t0, 0xFFFF0018
      sw a1, 0(t0) #coloca o valor de a1(argumento) no torque do motor 2
      j fim

    gps:
    gyroscope:
    g_time:
    s_time:
    w:
    
    salvador_de_registradores:.skip 124

    #restaura o contexto

    lw s11, 100(a0)
    lw s10, 96(a0)
    lw s9, 92(a0)
    lw s8, 88(a0)
    lw s7, 84(a0)
    lw s6, 80(a0)
    lw s5, 76(a0)
    lw s4, 72(a0)
    lw s3, 68(a0)
    lw s2, 64(a0)
    lw s1, 60(a0)
    lw s0, 56(a0)
    lw t6, 52(a0)
    lw t5, 48(a0)
    lw t4, 44(a0)
    lw t3, 40(a0)
    lw t2, 36(a0)
    lw t1, 32(a0)
    lw t0, 28(a0)
    lw a7, 24(a0)
    lw a6, 20(a0)
    lw a5, 16(a0)
    lw a4, 12(a0)
    lw a3, 8(a0)
    lw a2, 4(a0)
    lw a1, 0(a0)
    csrrw a0, mscratch, a0 # troca valor de a0 com mscratch
    mret # retorna do tratador

