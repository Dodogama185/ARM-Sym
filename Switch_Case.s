@Codigo de exemplo 1
@switch case
@Um exeplo simples de switch case pode ser observado no meu trabalho e no exemplo
@do fim do livro, esse seria o switch case usado na entrada do teclado azul!
@A logica vista lá pode ser aplicada para multiplas funções mas aqui está um 
@exemplo generico para vc trabalhar em cima

.text
 @Declaração dos Botoes Azuis 
  .equ BLUE_KEY_00, 0x01 @button(0)
  .equ BLUE_KEY_01, 0x02 @button(1)
  .equ BLUE_KEY_02, 0x04 @button(2)
  .equ BLUE_KEY_03, 0x08 @button(3)
  .equ BLUE_KEY_04, 0x10 @button(4)
  .equ BLUE_KEY_05, 0x20 @button(5)

 @Declaração de LEDS
  .equ LEFT_LED,0x02
  .equ RIGHT_LED, 0x01

 @Delarando Check e Controles
  .equ SWI_SETLED,0x201 @LEDs on/off
  .equ SWI_CheckBlue,0x203 @check press Blue button
  .equ SWI_DRAW_STRING, 0x204 @display a string on LCD
  .equ SWI_CLEAR_DISPLAY,0x206 @clear LCD
  .equ SWI_EXIT, 0x11 @terminate program
  .equ SWI_GetTicks, 0x6d @get current time

  .global _start @tem sempre que ter um espaço entre global e _start

 

_start:
 mov r0,#0
 swi SWI_SETLED @Both LEDs off
 swi SWI_CLEAR_DISPLAY @Limpa o display

  Liga_LED_DIREITA:
 
  mov r0,#2
  mov r0,#RIGHT_LED @Liga a LED direita 
  swi SWI_SETLED
  bal NextButtons

  Liga_LED_ESQUERDA:
  mov r0,#LEFT_LED @Liga a LED esquerda 
  swi SWI_SETLED
  @bal NextButtons -> nao é necessario porque está logo abaixo

  NextButtons:@Delay 
   ldr r3,=3000
   BL Wait  
   mov r0,#0
   swi SWI_SETLED @Both LEDs off

@Implementando a logica:
 Switch_Case:

  @Espera pelo input
  mov r0,#0
 loop:

  swi SWI_CheckBlue @get button press into R0
  cmp r0,#0
  beq loop @ if zero, no button pressed
  cmp r0,#BLUE_KEY_01
  beq Case2
  cmp r0,#BLUE_KEY_00
  beq Case1
  mov r0,#4 

 
 Case1:
  @
  @
  @
  @
  bal Liga_LED_DIREITA 

 Case2:
  @
  @
  @
  @
  bal Liga_LED_ESQUERDA






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
  