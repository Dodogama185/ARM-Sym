.text
 @Declaração dos Botões Azuis 
  .equ BLUE_KEY_00, 0x01 @button(0)
  .equ BLUE_KEY_01, 0x02 @button(1)
  .equ BLUE_KEY_02, 0x04 @button(2)
  .equ BLUE_KEY_03, 0x08 @button(3)
  .equ BLUE_KEY_04, 0x10 @button(4)
  .equ BLUE_KEY_05, 0x20 @button(5)
  .equ BLUE_KEY_06, 0x40 @button(6)
  .equ BLUE_KEY_07, 0x80 @button(7)
  .equ BLUE_KEY_08, 0x100 @button(8) 
  .equ BLUE_KEY_09, 0x200 @button(9)
  .equ BLUE_KEY_10, 0x400 @button(10)
  .equ BLUE_KEY_11, 0x800 @button(11)

   
 @bit patterns for black buttons
  .equ LEFT_BLACK_BUTTON,0x02
  .equ RIGHT_BLACK_BUTTON,0x01

 @Declaração de LEDS
  .equ LEFT_LED,0x02
  .equ RIGHT_LED, 0x01

 @Delarando Check e Controles
  .equ SWI_SETLED,0x201 @LEDs on/off
  .equ SWI_CheckBlack, 0x202 @check Black button
  .equ SWI_CheckBlue,0x203 @check press Blue button
  .equ SWI_DRAW_STRING, 0x204 @display a string on LCD
  .equ SWI_DRAW_INT,0x205 @display an int on LCD
  .equ SWI_CLEAR_DISPLAY,0x206 @clear LCD
  .equ SWI_DRAW_CHAR, 0x207 @display a char on LCD
  .equ SWI_CLEAR_LINE, 0x208 @clear a line on LCD
  .equ SWI_EXIT, 0x11 @terminate program
  .equ SWI_GetTicks, 0x6d @get current time
  
  .global _start @tem sempre que ter um espaço entre global e _start

 

_start:
 mov r0,#0
 swi SWI_CheckBlack
 swi SWI_SETLED @Both LEDs off
 swi SWI_CLEAR_DISPLAY @Limpa o display


 PAGAMENTO:
 @O cliente pode colocar notas de 5 reais na maquina
 @Teoricamente o sensor acularia a entrada de dinheiro
 @Como não temos sensor é nescesario o aperto de um botão que
 @equivale a entrada de dinheiro

 mov r0,#2 @ Numero de coluna
 mov r1,#1 @ Numero de linha
 ldr r2,=Pagamento @ ponteiro de string
 swi SWI_DRAW_STRING @ Escreve na tela LCD
 


 CKBlack:
  @botão preto significa comprar
  @a ação de fazer compra reduz a 

  mov r7,#0 @sera usado para receber o pagamento
  mov r4,#0
  ldr r7,=Saldo
  ldr r7,[r7]
  ldr r4,[r7]


  @Loop Esperando o botão preto ser apertado:
  LB1:
  @Botão esquedo adiciona dinheiro
  @Botão direito para de receber e vai para o loop de compra
  
  swi SWI_CheckBlack @get button press into R0
  cmp r0,#0
  beq LB1 @ if zero, no button pressed
  cmp r0,#RIGHT_BLACK_BUTTON
  bne LB_Esquerdo @se não igual a botão da direita vá para o esquerdo
  
  LB_Direito:
 
  mov r0,#2
  swi SWI_CLEAR_LINE  @Limpa a linha
  mov r0,#RIGHT_LED @Liga a LED direita 
  swi SWI_SETLED
  mov r0,#1 @ Numero de coluna
  mov r1,#2 @ Numero de linha
  ldr r2,=Pagamento2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#7 @ Numero de coluna
  mov r1,#2 @ Numero de linha
  ldr r2,=Saldo
  swi SWI_DRAW_INT @ Escreve na tela LCD
  mov r0,#10 @ Numero de coluna
  mov r1,#2 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  bal NextButtons

  LB_Esquerdo:
  mov r0,#LEFT_LED @Liga a LED esquerda 
  swi SWI_SETLED
  mov r3,#5
  add r7,r7,r3
  str r7,=Saldo

  bal LB1

  NextButtons:@Delay 
   ldr r3,=3000
   BL Wait
  
   
  mov r0,#0
  swi SWI_SETLED @Both LEDs off


 @Saiu do loop de pagamento:

 swi SWI_CLEAR_DISPLAY @Limpa o display
 mov r0,#2 @ Numero de coluna
 mov r1,#1 @ Numero de linha
 ldr r2,=Escolha @ ponteiro de string
 swi SWI_DRAW_STRING @ Escreve na tela LCD

 mov r0,#3 @ Numero de coluna
 mov r1,#2 @ Numero de linha
 ldr r2,=Resposta @ ponteiro de string
 swi SWI_DRAW_STRING @ Escreve na tela LCD
 




@Escolhendo o produto:
 BLUELOOP:

  @wait for user to press blue button
  mov r0,#0
 BB1:

  swi SWI_CheckBlue @get button press into R0
  cmp r0,#0
  beq BB1 @ if zero, no button pressed
  cmp r0,#BLUE_KEY_11
  beq ELEVEN
  cmp r0,#BLUE_KEY_10
  beq TEN
  cmp r0,#BLUE_KEY_09
  beq NINE
  cmp r0,#BLUE_KEY_08
  beq EIGHT
  cmp r0,#BLUE_KEY_07
  beq SEVEN
  cmp r0,#BLUE_KEY_06
  beq SIX
  cmp r0,#BLUE_KEY_05
  beq FIVE
  cmp r0,#BLUE_KEY_04
  beq FOUR
  cmp r0,#BLUE_KEY_03
  beq THREE
  cmp r0,#BLUE_KEY_02
  beq TWO
  cmp r0,#BLUE_KEY_01
  beq ONE
  cmp r0,#BLUE_KEY_00
  beq ZERO
  mov r0,#4
  swi SWI_CLEAR_LINE
  mov r1,#0
  mov r0,#0
 

 
 ZERO:
  @Limpa as linhas
  mov r0,#3
  swi SWI_CLEAR_LINE
  mov r0,#4
  swi SWI_CLEAR_LINE
  mov r0,#5
  swi SWI_CLEAR_LINE

  @Escreve o nome do produto
  mov r0,#10 @ Numero de coluna
  mov r1,#3 @ Numero de linha
  ldr r2,=Snack0 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o texto "Tem" 
  mov r0,#6 @ Numero de coluna
  mov r1,#4 @ Numero de linha
  ldr r2,=Quantidade @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

 

  @Escreve a quantidade do protudo em estoque
  mov r0,#10 @ Numero de coluna
  mov r1,#4   @ Numero de linha

  @Recebe a quantidade do produto no armazem do Q_Snack
  @E reduz o numero em estoque
  ldr r6,=Q_Snack0   @ Carregar o endereço de Q_Snack0 para r6
  ldr r6,[r6]        @ Carregar o valor armazenado em Q_Snack0
  @Verifica se tem mais de 0 do produto
  mov r7,#0
  cmp r6,r7
  beq SeZero
  mov r3,#1          @ Preparar a constante 1
  sub r6,r6,r3       @ Subtrair 1 do valor de Q_Snack0
  ldr r7,=Q_Snack0   @ Carregar o endereço de Q_Snack0 em r7
  str r6,[r7]        @ Armazenar o novo valor de volta em Q_Snack0
  ldr r2,=Q_Snack0   @ Carregar o endereço de Q_Snack0 para r2
  ldr r2,[r2]        @ Carregar o valor atualizado de Q_Snack0
  swi SWI_DRAW_INT   @ Exibir o valor de Q_Snack0 no display

  @Escreve o texto " em estoque"
  mov r0,#14 @ Numero de coluna
  ldr r2,=Quantidade2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  
  
  @Escreve o aviso do valor do produto:

  mov r0,#6 @ Numero de coluna
  mov r1,#5 @ Numero de linha
  ldr r2,=Valor @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#18 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  
  @Escreve o Preço do produto:
  mov r0,#15 @ Numero de coluna
  ldr r5,=P_Snack0
  ldr r5,[r5]
  mov r2,r5
  swi SWI_DRAW_INT @ Escreve na tela LCD

  @Efetuar a compra: 
  @Se o saldo for menor que o preço do produto dá mensagem de erro e manda ele escolher outro produto
  ldr r7,=Saldo

  cmp r5,r7
  bgt SeZero
  
  @Caso o preço seja menor que o saldo
  @Reduz o saldo no valor do preço
  sub r7,r7,r5
  str r7,=Saldo
  mov r0,#1 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Pagamento2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#7 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Saldo
  swi SWI_DRAW_INT @ Escreve na tela LCD
  mov r0,#10 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
 
  @Volta para a detecção do botão preto
  @Dando oportunidade para adicionar dinheiro
  bal LB1 

 ONE:
  @Limpa as linhas
  mov r0,#3
  swi SWI_CLEAR_LINE
  mov r0,#4
  swi SWI_CLEAR_LINE
  mov r0,#5
  swi SWI_CLEAR_LINE

  @Escreve o nome do produto
  mov r0,#10 @ Numero de coluna
  mov r1,#3 @ Numero de linha
  ldr r2,=Snack1 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o texto "Tem"
  mov r0,#6 @ Numero de coluna
  mov r1,#4 @ Numero de linha
  ldr r2,=Quantidade @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve a quantidade do produto em estoque
  mov r0,#10 @ Numero de coluna
  mov r1,#4   @ Numero de linha

  @Recebe a quantidade do produto no armazem do Q_Snack
  @E reduz o numero em estoque
  ldr r6,=Q_Snack1   @ Carregar o endereço de Q_Snack1 para r6
  ldr r6,[r6]        @ Carregar o valor armazenado em Q_Snack1
  @Verifica se tem mais de 0 do produto
  mov r7,#0
  cmp r6,r7
  beq SeZero
  mov r3,#1          @ Preparar a constante 1
  sub r6,r6,r3       @ Subtrair 1 do valor de Q_Snack1
  ldr r7,=Q_Snack1   @ Carregar o endereço de Q_Snack1 em r7
  str r6,[r7]        @ Armazenar o novo valor de volta em Q_Snack1
  ldr r2,=Q_Snack1   @ Carregar o endereço de Q_Snack1 para r2
  ldr r2,[r2]        @ Carregar o valor atualizado de Q_Snack1
  swi SWI_DRAW_INT   @ Exibir o valor de Q_Snack1 no display

  @Escreve o texto " em estoque"
  mov r0,#14 @ Numero de coluna
  ldr r2,=Quantidade2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD


  
  @Escreve o aviso do valor do produto:
  mov r0,#6 @ Numero de coluna
  mov r1,#5 @ Numero de linha
  ldr r2,=Valor @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#18 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  
  @Escreve o Preço do produto:
  mov r0,#15 @ Numero de coluna
  ldr r5,=P_Snack1
  ldr r5,[r5]
  mov r2,r5
  swi SWI_DRAW_INT @ Escreve na tela LCD

  @Efetuar a compra:
  @Se o saldo for menor que o preço do produto dá mensagem de erro e manda ele escolher outro produto
  ldr r7,=Saldo

  cmp r5,r7
  bgt SeZero
  
  @Caso o preço seja menor que o saldo
  @Reduz o saldo no valor do preço
  sub r7,r7,r5
  str r7,=Saldo
  mov r0,#1 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Pagamento2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#7 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Saldo
  swi SWI_DRAW_INT @ Escreve na tela LCD
  mov r0,#10 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Volta para a detecção do botão preto
  @Dando oportunidade para adicionar dinheiro
  bal LB1

 
 TWO:
  @Limpa as linhas
  mov r0,#3
  swi SWI_CLEAR_LINE
  mov r0,#4
  swi SWI_CLEAR_LINE
  mov r0,#5
  swi SWI_CLEAR_LINE

  @Escreve o nome do produto
  mov r0,#10 @ Numero de coluna
  mov r1,#3 @ Numero de linha
  ldr r2,=Snack2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o texto "Tem" 
  mov r0,#6 @ Numero de coluna
  mov r1,#4 @ Numero de linha
  ldr r2,=Quantidade @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve a quantidade do produto em estoque
  mov r0,#10 @ Numero de coluna
  mov r1,#4   @ Numero de linha

  @Recebe a quantidade do produto no armazém do Q_Snack
  @E reduz o número em estoque
  ldr r6,=Q_Snack2   @ Carregar o endereço de Q_Snack2 para r6
  ldr r6,[r6]        @ Carregar o valor armazenado em Q_Snack2
  @Verifica se tem mais de 0 do produto
  mov r7,#0
  cmp r6,r7
  beq SeZero
  mov r3,#1          @ Preparar a constante 1
  sub r6,r6,r3       @ Subtrair 1 do valor de Q_Snack2
  ldr r7,=Q_Snack2   @ Carregar o endereço de Q_Snack2 em r7
  str r6,[r7]        @ Armazenar o novo valor de volta em Q_Snack2
  ldr r2,=Q_Snack2   @ Carregar o endereço de Q_Snack2 para r2
  ldr r2,[r2]        @ Carregar o valor atualizado de Q_Snack2
  swi SWI_DRAW_INT   @ Exibir o valor de Q_Snack2 no display

  @Escreve o texto " em estoque"
  mov r0,#14 @ Numero de coluna
  ldr r2,=Quantidade2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o aviso do valor do produto:
  mov r0,#6 @ Numero de coluna
  mov r1,#5 @ Numero de linha
  ldr r2,=Valor @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#18 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  
  @Escreve o Preço do produto:
  mov r0,#15 @ Numero de coluna
  ldr r5,=P_Snack2
  ldr r5,[r5]
  mov r2,r5
  swi SWI_DRAW_INT @ Escreve na tela LCD

  @Efetuar a compra: 
  @Se o saldo for menor que o preço do produto dá mensagem de erro e manda ele escolher outro produto
  ldr r7,=Saldo
  cmp r5,r7
  bgt SeZero
  
  @Caso o preço seja menor que o saldo
  @Reduz o saldo no valor do preço
  sub r7,r7,r5
  str r7,=Saldo
  mov r0,#1 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Pagamento2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#7 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Saldo
  swi SWI_DRAW_INT @ Escreve na tela LCD
  mov r0,#10 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
 
  @Volta para a detecção do botão preto
  @Dando oportunidade para adicionar dinheiro
  bal LB1

 
 THREE:
  @Limpa as linhas
  mov r0,#3
  swi SWI_CLEAR_LINE
  mov r0,#4
  swi SWI_CLEAR_LINE
  mov r0,#5
  swi SWI_CLEAR_LINE

  @Escreve o nome do produto
  mov r0,#10 @ Numero de coluna
  mov r1,#3 @ Numero de linha
  ldr r2,=Snack3 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o texto "Tem" 
  mov r0,#6 @ Numero de coluna
  mov r1,#4 @ Numero de linha
  ldr r2,=Quantidade @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve a quantidade do produto em estoque
  mov r0,#10 @ Numero de coluna
  mov r1,#4   @ Numero de linha

  @Recebe a quantidade do produto no armazém do Q_Snack
  @E reduz o número em estoque
  ldr r6,=Q_Snack3   @ Carregar o endereço de Q_Snack3 para r6
  ldr r6,[r6]        @ Carregar o valor armazenado em Q_Snack3
  @Verifica se tem mais de 0 do produto
  mov r7,#0
  cmp r6,r7
  beq SeZero
  mov r3,#1          @ Preparar a constante 1
  sub r6,r6,r3       @ Subtrair 1 do valor de Q_Snack3
  ldr r7,=Q_Snack3   @ Carregar o endereço de Q_Snack3 em r7
  str r6,[r7]        @ Armazenar o novo valor de volta em Q_Snack3
  ldr r2,=Q_Snack3   @ Carregar o endereço de Q_Snack3 para r2
  ldr r2,[r2]        @ Carregar o valor atualizado de Q_Snack3
  swi SWI_DRAW_INT   @ Exibir o valor de Q_Snack3 no display

  @Escreve o texto " em estoque"
  mov r0,#14 @ Numero de coluna
  ldr r2,=Quantidade2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o aviso do valor do produto:
  mov r0,#6 @ Numero de coluna
  mov r1,#5 @ Numero de linha
  ldr r2,=Valor @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#18 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  
  @Escreve o Preço do produto:
  mov r0,#15 @ Numero de coluna
  ldr r5,=P_Snack3
  ldr r5,[r5]
  mov r2,r5
  swi SWI_DRAW_INT @ Escreve na tela LCD

  @Efetuar a compra: 
  @Se o saldo for menor que o preço do produto dá mensagem de erro e manda ele escolher outro produto
  ldr r7,=Saldo
  cmp r5,r7
  bgt SeZero
  
  @Caso o preço seja menor que o saldo
  @Reduz o saldo no valor do preço
  sub r7,r7,r5
  str r7,=Saldo
  mov r0,#1 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Pagamento2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#7 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Saldo
  swi SWI_DRAW_INT @ Escreve na tela LCD
  mov r0,#10 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
 
  @Volta para a detecção do botão preto
  @Dando oportunidade para adicionar dinheiro
  bal LB1

 
 FOUR:
  @Limpa as linhas
  mov r0,#3
  swi SWI_CLEAR_LINE
  mov r0,#4
  swi SWI_CLEAR_LINE
  mov r0,#5
  swi SWI_CLEAR_LINE

  @Escreve o nome do produto
  mov r0,#10 @ Numero de coluna
  mov r1,#3 @ Numero de linha
  ldr r2,=Snack4 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o texto "Tem" 
  mov r0,#6 @ Numero de coluna
  mov r1,#4 @ Numero de linha
  ldr r2,=Quantidade @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve a quantidade do produto em estoque
  mov r0,#10 @ Numero de coluna
  mov r1,#4   @ Numero de linha

  @Recebe a quantidade do produto no armazém do Q_Snack
  @E reduz o número em estoque
  ldr r6,=Q_Snack4   @ Carregar o endereço de Q_Snack4 para r6
  ldr r6,[r6]        @ Carregar o valor armazenado em Q_Snack4
  @Verifica se tem mais de 0 do produto
  mov r7,#0
  cmp r6,r7
  beq SeZero
  mov r3,#1          @ Preparar a constante 1
  sub r6,r6,r3       @ Subtrair 1 do valor de Q_Snack4
  ldr r7,=Q_Snack4   @ Carregar o endereço de Q_Snack4 em r7
  str r6,[r7]        @ Armazenar o novo valor de volta em Q_Snack4
  ldr r2,=Q_Snack4   @ Carregar o endereço de Q_Snack4 para r2
  ldr r2,[r2]        @ Carregar o valor atualizado de Q_Snack4
  swi SWI_DRAW_INT   @ Exibir o valor de Q_Snack4 no display

  @Escreve o texto " em estoque"
  mov r0,#14 @ Numero de coluna
  ldr r2,=Quantidade2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o aviso do valor do produto:
  mov r0,#6 @ Numero de coluna
  mov r1,#5 @ Numero de linha
  ldr r2,=Valor @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#18 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  
  @Escreve o Preço do produto:
  mov r0,#15 @ Numero de coluna
  ldr r5,=P_Snack4
  ldr r5,[r5]
  mov r2,r5
  swi SWI_DRAW_INT @ Escreve na tela LCD

  @Efetuar a compra: 
  @Se o saldo for menor que o preço do produto dá mensagem de erro e manda ele escolher outro produto
  ldr r7,=Saldo
  cmp r5,r7
  bgt SeZero
  
  @Caso o preço seja menor que o saldo
  @Reduz o saldo no valor do preço
  sub r7,r7,r5
  str r7,=Saldo
  mov r0,#1 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Pagamento2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#7 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Saldo
  swi SWI_DRAW_INT @ Escreve na tela LCD
  mov r0,#10 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
 
  @Volta para a detecção do botão preto
  @Dando oportunidade para adicionar dinheiro
  bal LB1

 
 FIVE:
  @Limpa as linhas
  mov r0,#3
  swi SWI_CLEAR_LINE
  mov r0,#4
  swi SWI_CLEAR_LINE
  mov r0,#5
  swi SWI_CLEAR_LINE

  @Escreve o nome do produto
  mov r0,#10 @ Numero de coluna
  mov r1,#3 @ Numero de linha
  ldr r2,=Snack5 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o texto "Tem"
  mov r0,#6 @ Numero de coluna
  mov r1,#4 @ Numero de linha
  ldr r2,=Quantidade @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve a quantidade do produto em estoque
  mov r0,#10 @ Numero de coluna
  mov r1,#4   @ Numero de linha

  @Recebe a quantidade do produto no armazém do Q_Snack
  @E reduz o número em estoque
  ldr r6,=Q_Snack5   @ Carregar o endereço de Q_Snack5 para r6
  ldr r6,[r6]        @ Carregar o valor armazenado em Q_Snack5
  @Verifica se tem mais de 0 do produto
  mov r7,#0
  cmp r6,r7
  beq SeZero
  mov r3,#1          @ Preparar a constante 1
  sub r6,r6,r3       @ Subtrair 1 do valor de Q_Snack5
  ldr r7,=Q_Snack5   @ Carregar o endereço de Q_Snack5 em r7
  str r6,[r7]        @ Armazenar o novo valor de volta em Q_Snack5
  ldr r2,=Q_Snack5   @ Carregar o endereço de Q_Snack5 para r2
  ldr r2,[r2]        @ Carregar o valor atualizado de Q_Snack5
  swi SWI_DRAW_INT   @ Exibir o valor de Q_Snack5 no display

  @Escreve o texto " em estoque"
  mov r0,#14 @ Numero de coluna
  ldr r2,=Quantidade2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o aviso do valor do produto:
  mov r0,#6 @ Numero de coluna
  mov r1,#5 @ Numero de linha
  ldr r2,=Valor @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#18 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o Preço do produto:
  mov r0,#15 @ Numero de coluna
  ldr r5,=P_Snack5
  ldr r5,[r5]
  mov r2,r5
  swi SWI_DRAW_INT @ Escreve na tela LCD

  @Efetuar a compra:
  @Se o saldo for menor que o preço do produto dá mensagem de erro e manda ele escolher outro produto
  ldr r7,=Saldo
  cmp r5,r7
  bgt SeZero

  @Caso o preço seja menor que o saldo
  @Reduz o saldo no valor do preço
  sub r7,r7,r5
  str r7,=Saldo
  mov r0,#1 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Pagamento2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#7 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Saldo
  swi SWI_DRAW_INT @ Escreve na tela LCD
  mov r0,#10 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Volta para a detecção do botão preto
  @Dando oportunidade para adicionar dinheiro
  bal LB1

 
 SIX:
  @Limpa as linhas
  mov r0,#3
  swi SWI_CLEAR_LINE
  mov r0,#4
  swi SWI_CLEAR_LINE
  mov r0,#5
  swi SWI_CLEAR_LINE

  @Escreve o nome do produto
  mov r0,#10 @ Numero de coluna
  mov r1,#3 @ Numero de linha
  ldr r2,=Snack6 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o texto "Tem"
  mov r0,#6 @ Numero de coluna
  mov r1,#4 @ Numero de linha
  ldr r2,=Quantidade @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve a quantidade do produto em estoque
  mov r0,#10 @ Numero de coluna
  mov r1,#4   @ Numero de linha

  @Recebe a quantidade do produto no armazém do Q_Snack
  @E reduz o número em estoque
  ldr r6,=Q_Snack6   @ Carregar o endereço de Q_Snack6 para r6
  ldr r6,[r6]        @ Carregar o valor armazenado em Q_Snack6
  @Verifica se tem mais de 0 do produto
  mov r7,#0
  cmp r6,r7
  beq SeZero
  mov r3,#1          @ Preparar a constante 1
  sub r6,r6,r3       @ Subtrair 1 do valor de Q_Snack6
  ldr r7,=Q_Snack6   @ Carregar o endereço de Q_Snack6 em r7
  str r6,[r7]        @ Armazenar o novo valor de volta em Q_Snack6
  ldr r2,=Q_Snack6   @ Carregar o endereço de Q_Snack6 para r2
  ldr r2,[r2]        @ Carregar o valor atualizado de Q_Snack6
  swi SWI_DRAW_INT   @ Exibir o valor de Q_Snack6 no display

  @Escreve o texto " em estoque"
  mov r0,#14 @ Numero de coluna
  ldr r2,=Quantidade2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o aviso do valor do produto:
  mov r0,#6 @ Numero de coluna
  mov r1,#5 @ Numero de linha
  ldr r2,=Valor @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#18 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o Preço do produto:
  mov r0,#15 @ Numero de coluna
  ldr r5,=P_Snack6
  ldr r5,[r5]
  mov r2,r5
  swi SWI_DRAW_INT @ Escreve na tela LCD

  @Efetuar a compra:
  @Se o saldo for menor que o preço do produto dá mensagem de erro e manda ele escolher outro produto
  ldr r7,=Saldo
  cmp r5,r7
  bgt SeZero

  @Caso o preço seja menor que o saldo
  @Reduz o saldo no valor do preço
  sub r7,r7,r5
  str r7,=Saldo
  mov r0,#1 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Pagamento2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#7 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Saldo
  swi SWI_DRAW_INT @ Escreve na tela LCD
  mov r0,#10 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Volta para a detecção do botão preto
  @Dando oportunidade para adicionar dinheiro
  bal LB1

 
 SEVEN:
  @Limpa as linhas
  mov r0,#3
  swi SWI_CLEAR_LINE
  mov r0,#4
  swi SWI_CLEAR_LINE
  mov r0,#5
  swi SWI_CLEAR_LINE

  @Escreve o nome do produto
  mov r0,#10 @ Numero de coluna
  mov r1,#3 @ Numero de linha
  ldr r2,=Snack7 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o texto "Tem"
  mov r0,#6 @ Numero de coluna
  mov r1,#4 @ Numero de linha
  ldr r2,=Quantidade @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve a quantidade do produto em estoque
  mov r0,#10 @ Numero de coluna
  mov r1,#4   @ Numero de linha

  @Recebe a quantidade do produto no armazém do Q_Snack
  @E reduz o número em estoque
  ldr r6,=Q_Snack7   @ Carregar o endereço de Q_Snack7 para r6
  ldr r6,[r6]        @ Carregar o valor armazenado em Q_Snack7
  @Verifica se tem mais de 0 do produto
  mov r7,#0
  cmp r6,r7
  beq SeZero
  mov r3,#1          @ Preparar a constante 1
  sub r6,r6,r3       @ Subtrair 1 do valor de Q_Snack7
  ldr r7,=Q_Snack7   @ Carregar o endereço de Q_Snack7 em r7
  str r6,[r7]        @ Armazenar o novo valor de volta em Q_Snack7
  ldr r2,=Q_Snack7   @ Carregar o endereço de Q_Snack7 para r2
  ldr r2,[r2]        @ Carregar o valor atualizado de Q_Snack7
  swi SWI_DRAW_INT   @ Exibir o valor de Q_Snack7 no display

  @Escreve o texto " em estoque"
  mov r0,#14 @ Numero de coluna
  ldr r2,=Quantidade2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o aviso do valor do produto:
  mov r0,#6 @ Numero de coluna
  mov r1,#5 @ Numero de linha
  ldr r2,=Valor @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#18 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o Preço do produto:
  mov r0,#15 @ Numero de coluna
  ldr r5,=P_Snack7
  ldr r5,[r5]
  mov r2,r5
  swi SWI_DRAW_INT @ Escreve na tela LCD

  @Efetuar a compra:
  @Se o saldo for menor que o preço do produto dá mensagem de erro e manda ele escolher outro produto
  ldr r7,=Saldo
  cmp r5,r7
  bgt SeZero

  @Caso o preço seja menor que o saldo
  @Reduz o saldo no valor do preço
  sub r7,r7,r5
  str r7,=Saldo
  mov r0,#1 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Pagamento2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#7 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Saldo
  swi SWI_DRAW_INT @ Escreve na tela LCD
  mov r0,#10 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Volta para a detecção do botão preto
  @Dando oportunidade para adicionar dinheiro
  bal LB1

 
 EIGHT:
  @Limpa as linhas
  mov r0,#3
  swi SWI_CLEAR_LINE
  mov r0,#4
  swi SWI_CLEAR_LINE
  mov r0,#5
  swi SWI_CLEAR_LINE

  @Escreve o nome do produto
  mov r0,#10 @ Numero de coluna
  mov r1,#3 @ Numero de linha
  ldr r2,=Snack8 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o texto "Tem"
  mov r0,#6 @ Numero de coluna
  mov r1,#4 @ Numero de linha
  ldr r2,=Quantidade @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve a quantidade do produto em estoque
  mov r0,#10 @ Numero de coluna
  mov r1,#4   @ Numero de linha

  @Recebe a quantidade do produto no armazém do Q_Snack
  @E reduz o número em estoque
  ldr r6,=Q_Snack8   @ Carregar o endereço de Q_Snack8 para r6
  ldr r6,[r6]        @ Carregar o valor armazenado em Q_Snack8
  @Verifica se tem mais de 0 do produto
  mov r7,#0
  cmp r6,r7
  beq SeZero
  mov r3,#1          @ Preparar a constante 1
  sub r6,r6,r3       @ Subtrair 1 do valor de Q_Snack8
  ldr r7,=Q_Snack8   @ Carregar o endereço de Q_Snack8 em r7
  str r6,[r7]        @ Armazenar o novo valor de volta em Q_Snack8
  ldr r2,=Q_Snack8   @ Carregar o endereço de Q_Snack8 para r2
  ldr r2,[r2]        @ Carregar o valor atualizado de Q_Snack8
  swi SWI_DRAW_INT   @ Exibir o valor de Q_Snack8 no display

  @Escreve o texto " em estoque"
  mov r0,#14 @ Numero de coluna
  ldr r2,=Quantidade2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o aviso do valor do produto:
  mov r0,#6 @ Numero de coluna
  mov r1,#5 @ Numero de linha
  ldr r2,=Valor @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#18 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o Preço do produto:
  mov r0,#15 @ Numero de coluna
  ldr r5,=P_Snack8
  ldr r5,[r5]
  mov r2,r5
  swi SWI_DRAW_INT @ Escreve na tela LCD

  @Efetuar a compra:
  @Se o saldo for menor que o preço do produto dá mensagem de erro e manda ele escolher outro produto
  ldr r7,=Saldo
  cmp r5,r7
  bgt SeZero

  @Caso o preço seja menor que o saldo
  @Reduz o saldo no valor do preço
  sub r7,r7,r5
  str r7,=Saldo
  mov r0,#1 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Pagamento2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#7 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Saldo
  swi SWI_DRAW_INT @ Escreve na tela LCD
  mov r0,#10 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Volta para a detecção do botão preto
  @Dando oportunidade para adicionar dinheiro
  bal LB1

 
 NINE:
  @Limpa as linhas
  mov r0,#3
  swi SWI_CLEAR_LINE
  mov r0,#4
  swi SWI_CLEAR_LINE
  mov r0,#5
  swi SWI_CLEAR_LINE

  @Escreve o nome do produto
  mov r0,#10 @ Numero de coluna
  mov r1,#3 @ Numero de linha
  ldr r2,=Snack9 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o texto "Tem"
  mov r0,#6 @ Numero de coluna
  mov r1,#4 @ Numero de linha
  ldr r2,=Quantidade @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve a quantidade do produto em estoque
  mov r0,#10 @ Numero de coluna
  mov r1,#4   @ Numero de linha

  @Recebe a quantidade do produto no armazém do Q_Snack
  @E reduz o número em estoque
  ldr r6,=Q_Snack9   @ Carregar o endereço de Q_Snack9 para r6
  ldr r6,[r6]        @ Carregar o valor armazenado em Q_Snack9
  @Verifica se tem mais de 0 do produto
  mov r7,#0
  cmp r6,r7
  beq SeZero
  mov r3,#1          @ Preparar a constante 1
  sub r6,r6,r3       @ Subtrair 1 do valor de Q_Snack9
  ldr r7,=Q_Snack9   @ Carregar o endereço de Q_Snack9 em r7
  str r6,[r7]        @ Armazenar o novo valor de volta em Q_Snack9
  ldr r2,=Q_Snack9   @ Carregar o endereço de Q_Snack9 para r2
  ldr r2,[r2]        @ Carregar o valor atualizado de Q_Snack9
  swi SWI_DRAW_INT   @ Exibir o valor de Q_Snack9 no display

  @Escreve o texto " em estoque"
  mov r0,#14 @ Numero de coluna
  ldr r2,=Quantidade2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o aviso do valor do produto:
  mov r0,#6 @ Numero de coluna
  mov r1,#5 @ Numero de linha
  ldr r2,=Valor @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#18 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o Preço do produto:
  mov r0,#15 @ Numero de coluna
  ldr r5,=P_Snack9
  ldr r5,[r5]
  mov r2,r5
  swi SWI_DRAW_INT @ Escreve na tela LCD

  @Efetuar a compra:
  @Se o saldo for menor que o preço do produto dá mensagem de erro e manda ele escolher outro produto
  ldr r7,=Saldo
  cmp r5,r7
  bgt SeZero

  @Caso o preço seja menor que o saldo
  @Reduz o saldo no valor do preço
  sub r7,r7,r5
  str r7,=Saldo
  mov r0,#1 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Pagamento2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#7 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Saldo
  swi SWI_DRAW_INT @ Escreve na tela LCD
  mov r0,#10 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Volta para a detecção do botão preto
  @Dando oportunidade para adicionar dinheiro
  bal LB1

 
 TEN:
  @Limpa as linhas
  mov r0,#3
  swi SWI_CLEAR_LINE
  mov r0,#4
  swi SWI_CLEAR_LINE
  mov r0,#5
  swi SWI_CLEAR_LINE

  @Escreve o nome do produto
  mov r0,#10 @ Numero de coluna
  mov r1,#3 @ Numero de linha
  ldr r2,=Snack10 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o texto "Tem"
  mov r0,#6 @ Numero de coluna
  mov r1,#4 @ Numero de linha
  ldr r2,=Quantidade @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve a quantidade do produto em estoque
  mov r0,#10 @ Numero de coluna
  mov r1,#4   @ Numero de linha

  @Recebe a quantidade do produto no armazém do Q_Snack
  @E reduz o número em estoque
  ldr r6,=Q_Snack10   @ Carregar o endereço de Q_Snack10 para r6
  ldr r6,[r6]         @ Carregar o valor armazenado em Q_Snack10
  @Verifica se tem mais de 0 do produto
  mov r7,#0
  cmp r6,r7
  beq SeZero
  mov r3,#1           @ Preparar a constante 1
  sub r6,r6,r3        @ Subtrair 1 do valor de Q_Snack10
  ldr r7,=Q_Snack10   @ Carregar o endereço de Q_Snack10 em r7
  str r6,[r7]         @ Armazenar o novo valor de volta em Q_Snack10
  ldr r2,=Q_Snack10   @ Carregar o endereço de Q_Snack10 para r2
  ldr r2,[r2]         @ Carregar o valor atualizado de Q_Snack10
  swi SWI_DRAW_INT    @ Exibir o valor de Q_Snack10 no display

  @Escreve o texto " em estoque"
  mov r0,#14 @ Numero de coluna
  ldr r2,=Quantidade2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o aviso do valor do produto:
  mov r0,#6 @ Numero de coluna
  mov r1,#5 @ Numero de linha
  ldr r2,=Valor @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#18 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o Preço do produto:
  mov r0,#15 @ Numero de coluna
  ldr r5,=P_Snack10
  ldr r5,[r5]
  mov r2,r5
  swi SWI_DRAW_INT @ Escreve na tela LCD

  @Efetuar a compra:
  @Se o saldo for menor que o preço do produto dá mensagem de erro e manda ele escolher outro produto
  ldr r7,=Saldo
  cmp r5,r7
  bgt SeZero

  @Caso o preço seja menor que o saldo
  @Reduz o saldo no valor do preço
  sub r7,r7,r5
  str r7,=Saldo
  mov r0,#1 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Pagamento2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#7 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Saldo
  swi SWI_DRAW_INT @ Escreve na tela LCD
  mov r0,#10 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Volta para a detecção do botão preto
  @Dando oportunidade para adicionar dinheiro
  bal LB1

 
 ELEVEN:
  @Limpa as linhas
  mov r0,#3
  swi SWI_CLEAR_LINE
  mov r0,#4
  swi SWI_CLEAR_LINE
  mov r0,#5
  swi SWI_CLEAR_LINE

  @Escreve o nome do produto
  mov r0,#10 @ Numero de coluna
  mov r1,#3 @ Numero de linha
  ldr r2,=Snack11 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o texto "Tem"
  mov r0,#6 @ Numero de coluna
  mov r1,#4 @ Numero de linha
  ldr r2,=Quantidade @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve a quantidade do produto em estoque
  mov r0,#10 @ Numero de coluna
  mov r1,#4   @ Numero de linha

  @Recebe a quantidade do produto no armazém do Q_Snack
  @E reduz o número em estoque
  ldr r6,=Q_Snack11   @ Carregar o endereço de Q_Snack11 para r6
  ldr r6,[r6]         @ Carregar o valor armazenado em Q_Snack11
  @Verifica se tem mais de 0 do produto
  mov r7,#0
  cmp r6,r7
  beq SeZero
  mov r3,#1           @ Preparar a constante 1
  sub r6,r6,r3        @ Subtrair 1 do valor de Q_Snack11
  ldr r7,=Q_Snack11   @ Carregar o endereço de Q_Snack11 em r7
  str r6,[r7]         @ Armazenar o novo valor de volta em Q_Snack11
  ldr r2,=Q_Snack11   @ Carregar o endereço de Q_Snack11 para r2
  ldr r2,[r2]         @ Carregar o valor atualizado de Q_Snack11
  swi SWI_DRAW_INT    @ Exibir o valor de Q_Snack11 no display

  @Escreve o texto " em estoque"
  mov r0,#14 @ Numero de coluna
  ldr r2,=Quantidade2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o aviso do valor do produto:
  mov r0,#6 @ Numero de coluna
  mov r1,#5 @ Numero de linha
  ldr r2,=Valor @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#18 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Escreve o Preço do produto:
  mov r0,#15 @ Numero de coluna
  ldr r5,=P_Snack11
  ldr r5,[r5]
  mov r2,r5
  swi SWI_DRAW_INT @ Escreve na tela LCD

  @Efetuar a compra:
  @Se o saldo for menor que o preço do produto dá mensagem de erro e manda ele escolher outro produto
  ldr r7,=Saldo
  cmp r5,r7
  bgt SeZero

  @Caso o preço seja menor que o saldo
  @Reduz o saldo no valor do preço
  sub r7,r7,r5
  str r7,=Saldo
  mov r0,#1 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Pagamento2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD
  mov r0,#7 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Saldo
  swi SWI_DRAW_INT @ Escreve na tela LCD
  mov r0,#10 @ Numero de coluna
  mov r1,#7 @ Numero de linha
  ldr r2,=Valor2 @ ponteiro de string
  swi SWI_DRAW_STRING @ Escreve na tela LCD

  @Volta para a detecção do botão preto
  @Dando oportunidade para adicionar dinheiro
  bal LB1

 


 @ ===== Wait(Delay:r3) wait for r3 milliseconds
 @ Delays for the amount of time stored in r3 for a 15-bit timer
 Wait:
  stmfd sp!,{r0-r5,lr}
  ldr r4,=0x00007FFF
  SWI SWI_GetTicks
  and r1,r0,r4
  Wloop:
   SWI SWI_GetTicks
   and r2,r0,r4
   @mask for 15-bit timer
   @Get start time
   @adjusted time to 15-bit
   @Get current time
   @adjusted time to 15-bit
   cmp r2,r1
   blt Roll
   sub r5,r2,r1
   bal CmpLoop
   Roll: sub r5,r4,r1
   add r5,r5,r2
   CmpLoop:cmp r5,r3
   blt Wloop
   @rolled above 15 bits
   @compute easy elapsed time
   @compute rolled elapsed time
   @is elapsed time < delay?
   @Continue with delay
   Xwait:ldmfd sp!,{r0-r5,pc}
 @ ================================================
  

  
 SeZero:
   mov r0,#6
   swi SWI_CLEAR_LINE
   mov r0,#2 @ Numero de coluna
   mov r1,#6 @ Numero de linha
   ldr r2,=S_Estoque @ ponteiro de string
   swi SWI_DRAW_STRING @ Escreve na tela LCD
   bal LB1



.data

 @Mensagens Do LED
 Escolha:.asciz "Escolha seu SNACK!"
 Resposta:.asciz "Voce escolheu: "
 Quantidade:.asciz "Tem "
 Quantidade2:.asciz "em estoque"
 Valor:.asciz "Custa: "
 Valor2:.asciz "Reais"
 S_Estoque:.asciz "Opcao invalida! Escolha outro produto"
 Pagamento:.asciz "Insira o dinheiro"
 Pagamento2:.asciz "Saldo:"
 Saldo:.word 0

 @Opções do Menu
    Snack0:.asciz "Choco Delight"
  Snack1:.asciz "Nutty Crunch"
  Snack2:.asciz "Caramel Wave"
  Snack3:.asciz "Berry Burst"
  Snack4:.asciz "Crispy Choc"
  Snack5:.asciz "Minty Fresh"
  Snack6:.asciz "Peanut Bliss"
  Snack7:.asciz "Coconut Dream"
  Snack8:.asciz "Almond Joy"
  Snack9:.asciz "Hazel Twist"
  Snack10:.asciz "Caramel Crunch"
  Snack11:.asciz "Fudge Fantasy"

 @Valores do Menu
  P_Snack0:.word 5
  P_Snack1:.word 5
  P_Snack2:.word 15
  P_Snack3:.word 20
  P_Snack4:.word 10
  P_Snack5:.word 10
  P_Snack6:.word 5
  P_Snack7:.word 5
  P_Snack8:.word 5
  P_Snack9:.word 5
  P_Snack10:.word 10
  P_Snack11:.word 10

   @Quantidade no estoque
  Q_Snack0:.word 3
  Q_Snack1:.word 1
  Q_Snack2:.word 2
  Q_Snack3:.word 3
  Q_Snack4:.word 4
  Q_Snack5:.word 5
  Q_Snack6:.word 6
  Q_Snack7:.word 7
  Q_Snack8:.word 8
  Q_Snack9:.word 9
  Q_Snack10:.word 10
  Q_Snack11:.word 11

.end