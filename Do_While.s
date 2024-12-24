@Codigo de exemplo 2
@Do while
@Novamente existe um exeplo simples de do while pode ser observado no meu trabalho e no exemplo
@do fim do livro, a logica vista lá pode ser aplicada para multiplas funções mas aqui está um 
@exemplo generico para vc trabalhar em cima
@Neste programa tera um loop de 10 repetições como determinado pela variavel Num
@Existe um loop dentro do loop "Loop_Do_While" chamado "Recebe" que recebe apertos do botão preto
@Caso você aperte 10 vezes o botão o contador Num vai chegar a 0 e o programa vai encerra

.text

  .equ SWI_EXIT, 0x11 @terminate program
  .equ SWI_CheckBlack, 0x202 @check Black button
  .equ SWI_DRAW_INT,0x205 @display an int on LCD
  .equ SWI_CLEAR_DISPLAY,0x206 @clear LCD
  .global _start @tem sempre que ter um espaço entre global e _start

_start:
 @Loop simples de receber entrada
mov r4,#0
mov r2,#0
mov r0,#0

ldr R4,=Num
ldr R4,[R4]
Loop_Do_While:
  swi SWI_CLEAR_DISPLAY
  mov r0,#2 @ Numero de coluna
  mov r1,#1 @ Numero de linha
  mov r2,r4
  swi SWI_DRAW_INT @ Escreve na tela LCD

  cmp r4,#0
  beq Sai_do_loop
  mov r5,#1
  sub r4,r4,r5
  str R4,=Num

Recebe:
  mov r0,#0
  swi SWI_CheckBlack
  cmp r0,#0
  beq Recebe
  bal Loop_Do_While



Sai_do_loop:
@Saiu do loop e já que a variavel chegou a 0
swi SWI_EXIT

.data

Num:.word 10

.end
