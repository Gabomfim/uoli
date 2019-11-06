.globl _start
.globl main

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
la t1, salvador_de_registradores # Coloca o endereço do buffer para salvar
csrw mscratch, t1 # registradores em mscratch
li sp, 134217724#seta o endereço da pilha
 
# Muda para o Modo de usuário
csrr t1, mstatus # Seta os bits 11 e 12 (MPP)
li t2, ~0x1800 # do registrador mstatus
and t1, t1, t2 # com o valor 00
csrw mstatus, t1
la t0, main # Grava o endereço do rótulo user
csrw mepc, t0 # no registrador mepc
mret # PC <= MEPC; MIE <= MPIE; Muda modo para MPP

int_handler:
    #salva o contexto
    

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
      csrr t0, mepc  # carrega endereÃ§o de retorno (endereÃ§o da instruÃ§Ã£o que invocou a syscall)
      addi t0, t0, 4 # soma 4 no endereÃ§o de retorno (para retornar apÃ³s a ecall) 
      csrw mepc, t0  # armazena endereÃ§o de retorno de volta no mepc
      li t0, 0
      li a0, 0
      li a1, 5
      beq a0, t0, motor1
      li t0, 1
      beq a0, t0, motor2
      motor1:
      li t0, 0xFFFF001A
      sw a1, 0(t0) #coloca o valor de a1(argumento) no torque do motor 1

      mret
      motor2:
      li t0, 0xFFFF0018
      sw a1, 0(t0) #coloca o valor de a1(argumento) no torque do motor 2
      mret

    gps:
    gyroscope:
    g_time:
    s_time:
    w:

    salvador_de_registradores:.skip 124

    #restaura o contexto

