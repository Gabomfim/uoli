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
li sp, 134217724 #seta o endereço da pilha
 
# Muda para o Modo de usuário
csrr t1, mstatus # Seta os bits 11 e 12 (MPP)
li t2, ~0x1800 # do registrador mstatus
and t1, t1, t2 # com o valor 00
csrw mstatus, t1

#Configurar o GPT para gerar interrupções após 100ms
  li t1, 0xFFFF0100 #seta 100ms para memória
  li t2, 100
  sw t2, 0(t1)
  li t1, 0xFFFF0104 #verifica o valor na memória para ver se foi tratado
  li t2, 0
  sb t2, 0(t1)

#configura os servos pra posicao natural
#(Base = 31, Mid = 80, Top = 78);
li a0, 0 #base
li a1, 31
li a7, 17
ecall

li a0, 1 #mid
li a1, 30
li a7, 17
ecall

li a0, 2 #top
li a1, 78
li a7, 17
ecall

la t0, main # Grava o endereço do rótulo user
csrw mepc, t0 # no registrador mepc
mret # PC <= MEPC; MIE <= MPIE; Muda modo para MPP


# ==== Início do tratador de interrupção ====

int_handler:
    #salva o contexto - nunca usar t6!!!!
    csrrw t6, mscratch, t6 # como faz pra preservar o a0?
    sw a1, 0(t6) # salva a1 
    sw a2, 4(t6) # salva a2 
    sw a3, 8(t6) # salva a3 
    sw a4, 12(t6) # salva a4
    sw a5, 16(t6)
    sw a6, 20(t6)
    sw a7, 24(t6)
    sw t0, 28(t6)
    sw t1, 32(t6)
    sw t2, 36(t6)
    sw t3, 40(t6)
    sw t4, 44(t6)
    sw t5, 48(t6)
    sw a0, 52(t6) #a0 aqui
    sw s0, 56(t6)
    sw s1, 60(t6)
    sw s2, 64(t6)
    sw s3, 68(t6)
    sw s4, 72(t6)
    sw s5, 76(t6)
    sw s6, 80(t6)
    sw s7, 84(t6)
    sw s8, 88(t6)
    sw s9, 92(t6)
    sw s10, 96(t6)
    sw s11, 100(t6)

    verifica_gpt:
      csrrw t1, mcause, t1 
      li t2, 0
      bgt t1, t2, maior #verifica se mcause é menor que -1, se mcause é positivo continua o tratamento 
      
      li t3, 0xFFFF0104 #verifica GPT-int 1 ou 0
      lb t4, 0(t3)
      beq t4, zero, fim #se 0xFFFF0104 for 0 e mcause<0 vai pro fim
      li t2, 1
      beq t4, t2, gpt_ajuda #se 0xFFFF0104 for 1 e mcause<0 muda pra 0 e continua

    gpt_ajuda:
      la t1, tempo #conta tempo do sistema 
      lw t2, 0(t1)
      addi t2, t2, 100
      sw t2, 0(t1)
      li t3, 0xFFFF0104 #zera o GPT-int
      lb t4, 0(t3)      
      sb zero, 0(t3) 
      li t1, 100 #seta 100 no endereço
      la t2, 0xFFFF0100
      sw t1, 0(t2)
      j fim    
    maior:

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
    
    # ==== Início do ultrassonic ==== ainda não dá pra saber se isso aqui funciona ou não
    ultrassonic: #16
			leitor:
			li t0, 0xFFFF0020
			lw a0, 0(t0) #coloca o valor do endereço de t0 no a0
			li t1, 1
			beq a0, t1, sensor_value
			sensor_value:
			li t0, 0xFFFF0024
			lw a1, 0(t0) #coloca o valor do endereço de t0 no a1
			li t1, -1
			beq a1, t1, inexistente #caso não exista
			lw a0, 0(t0) #coloca valor do sensor no a0
			ret
			inexistente:
			li a0, -1
			j fim
    # ==== Fim ====


    servo:
      li t0, 0
      beq a0, t0, servo_base
      li t0, 1
      beq a0, t0, servo_mid
      li t0, 2
      beq a0, t0, servo_top
      
      servo_base:
        li t0, 0xFFFF001E
        sb a1, 0(t0)
        j fim

      servo_mid:
        li t0, 0xFFFF001D
        sb a1, 0(t0)
        j fim
      servo_top:
        li t0, 0xFFFF001C
        sb a1, 0(t0)
        j fim

    engine: #18
      beq a0, t0, motor1
      beq a0, t0, motor2
      motor1:
        li t0, 0xFFFF001A
        sh a1, 0(t0) #coloca o valor de a1(argumento) no torque do motor 1
        j fim
      motor2:
        li t0, 0xFFFF0018
        sh a1, 0(t0) #coloca o valor de a1(argumento) no torque do motor 2
        j fim

    gps:
    gyroscope:

    # ==== Início do get_time: nenhum parâmetro e retorna o tempo do sistema em ms ====
    g_time: #21
      la t0, tempo
      lw a0, 0(t0)
      sw a0, 52(t6) #a0 aqui
      j fim


    # ==== Início do set_time: a0 - tempo do sistema em ms ====
    s_time: #22
      la t1, tempo
      sw a0, 0(t1)
      j fim

    # ==== Início do Write: a1 - endereço de memória, a2 - número de bytes a serem escritos ====
    w: #64
      mv t0, a2 #contador do vetor
      transmite:
        beq t0, x0, continua
        li t3, 0xFFFF0109 #carrega o byte no endereço que o UART vai transmitir
        lb t4, 0(a1)
        sb t4, 0(t3)
        li t1, 1
        li t2, 0xFFFF0108
        sb t1, 0(t2) #enable UART
          busywaiting:
            lb t5, 0(t2)
            beq t5, zero, cont
            j busywaiting
      cont:    
        addi t0, t0, -1
        addi a1, a1, 1
        j transmite
      continua:
        mv a0, a2
        sw a0, 52(t6) #a0 aqui
        j fim
    # ==== Fim do write ==== 
      
    
    salvador_de_registradores:.skip 5000

    #restaura o contexto

    fim:

    lw s11, 100(t6)
    lw s10, 96(t6)
    lw s9, 92(t6)
    lw s8, 88(t6)
    lw s7, 84(t6)
    lw s6, 80(t6)
    lw s5, 76(t6)
    lw s4, 72(t6)
    lw s3, 68(t6)
    lw s2, 64(t6)
    lw s1, 60(t6)
    lw s0, 56(t6)
    lw a0, 52(t6) #a0 aqui
    lw t5, 48(t6)
    lw t4, 44(t6)
    lw t3, 40(t6)
    lw t2, 36(t6)
    lw t1, 32(t6)
    lw t0, 28(t6) 
    lw a7, 24(t6)
    lw a6, 20(t6)
    lw a5, 16(t6)
    lw a4, 12(t6)
    lw a3, 8(t6)
    lw a2, 4(t6)
    lw a1, 0(t6)
    csrrw t6, mscratch, t6 # troca valor de a0 com mscratch

    csrrw t0, mepc, t0  # carrega endereÃ§o de retorno (endereÃ§o da instruÃ§Ã£o que invocou a syscall)
    addi t0, t0, 4 # soma 4 no endereÃ§o de retorno (para retornar apÃ³s a ecall) 
    csrrw t0, mepc, t0  # armazena endereÃ§o de retorno de volta no mepc\
    #restaura registradores
    mret # retorna do tratador

# ==== Fim do tratador de interrupção ====



tempo: .skip 4