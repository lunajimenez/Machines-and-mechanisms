// ------------------------------------------------------
// Code name : Ejemplo de hallar pos, vel y acel en mecanismo
// Topic:      Analisis de posiciones,vel y acel.
// Author:     Luna K. Quintero J.
// Copyright (C) 2025 
// Date of creation: 09/04/2025
// ------------------------------------------------------

clc
clear

//____________________________________________
//Funcnione utiles
function z=carte(long,teta)
    z=long*[cos(teta);sin(teta)]; 
end



//____________________________________________
// Valores de entrada
r1    = 1.69
teta1 = 15.5*%pi/180
r2    = 1.0
r4_2  = 4.76
r5    = 4.55
r6    = 3.31
teta6 = %pi/2
w2    = 20
teta3 = 0
//_____________________________________________
//Variables globales
//_____________________________________________
//Lazos de posiciones
function f = lazo1P(x)
      R1   = carte(r1  ,teta1)
      R2   = carte(r2  ,teta2)
      R4_1 = carte(x(1), x(2))
      f = R1+R2-R4_1
endfunction 

function f = lazo2P(x)
      R3   = carte(x(1) ,teta3)
      R4_2 = carte(r4_2 ,teta4)
      R6   = carte(r6   ,teta6)
      R5   = carte(r5   , x(2))
      f = R3+R4_2-R6-R5
endfunction 

//_____________________________________________
//Lazos de velocidades
function f = lazo1V(x)
      V2   = carte(r2*w2,teta2+%pi/2)
      V4_1 = carte(x(1),teta4)+carte(r4_1*x(2),teta4+%pi/2)
      f    = V2 - V4_1
endfunction

function f = lazo2V(x)
      V3   = carte(x(1),teta3)
      V4_2 = carte(r4_2*w4,teta4+%pi/2)
      V5   = carte(r5*x(2),teta5+%pi/2)
      f = V3 + V4_2 - V5
endfunction

//_____________________________________________
//Lazos de aceleraciones
function f = lazo1A(x)
      A2   = carte(r2*(w2^2),teta2)
      A4_1 = carte(x(1),teta4)+2*carte(r4p*w4,teta4+%pi/2)+carte(r4_1*x(2),teta4+%pi/2)-carte(r4_1*(w4^2),teta4)
      f    = -A2 - A4_1
endfunction

function f = lazo2A(x)
      A3   = carte(x(1),teta3)
      A4_2 = carte(r4_2*alfa4,teta4+%pi/2)-carte(r4_2*(w4^2),teta4)
      A5   = carte(r5*x(2),teta5+%pi/2)-carte(r5*(w5^2),teta5)
      f = A3 + A4_2 - A5
endfunction

//Valor inicial
x0    = [2 ; 30*%pi/180]
x1    = [2 ; 30*%pi/180]
x2    = [-10  ; 60]
x3    = [25 ; 70]
x4    = [-200 ; -30]
x5    = [-150 ; -50]
i     = 1

//Inicio de ciclo para calculos
for teta2 = 0:%pi/40:%pi
    
    //Sol lazo #1 posiciones
    a = fsolve(x0,lazo1P,1e-4)
    r4_1  = a(1)
    teta4 = a(2)
    
    b = fsolve(x1,lazo2P,1e-4)
    r3    = b(1)
    teta5 = b(2)
    
    c = fsolve(x2,lazo1V,1e-4)
    r4p    = c(1)
    w4     = c(2)
    
    d = fsolve(x3,lazo2V,1e-4)
    r3p    = d(1)
    w5     = d(2)
    
    e = fsolve(x4,lazo1A,1e-4)
    r4pp   = e(1)
    alfa4  = e(2)
    
    f = fsolve(x5,lazo2A,1e-4)
    r3pp   = f(1)
    alfa5  = f(2)
    
    //Guarda viables para graficas
    TETA2(i)  = teta2*180/%pi

    R4_1(i)  =  a(1)
    TETA4(i) =  a(2)*180/%pi

    R3(i)    =  b(1)
    TETA5(i) =  b(2)*180/%pi

    R4P(i)   =  c(1)
    W4(i)    =  c(2)*60/(2*%pi)
    
    R3P(i)   =  d(1)
    W5(i)    =  d(2)*60/(2*%pi)
    
    R4PP (i) =  e(1)
    ALFA4 (i)=  e(2)
    
    R3PP (i) =  f(1)
    ALFA5 (i)=  f(2)
    
    //Actualiza posicion inicial
    x0 = a
    x1 = b
    x2 = c
    x3 = d
    x4 = e
    x5 = f
    
    //Variable contadora
    i  = i+1
end

//__________________________________________________________
//Resultados
subplot(3,2,1)
   plot(TETA2,TETA4)
   plot(TETA2,TETA5,'r')
   xtitle("Posicion angulares vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "Angulos (Grados)"); 
   legend("Teta4","Teta5")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))


subplot(3,2,2)
   plot(TETA2,R4_1)
   plot(TETA2,R3,'r')
   xtitle("Posicion lineales vs teta2", ...
          "Angulo teta_2 (Grados)",     ...
          "X (in)");
   legend("R4_1","R3")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))



subplot(3,2,3)
   plot(TETA2,R4P)
   plot(TETA2,R3P,'r')
   xtitle("Velocidades lineales vs teta2", ...
          "Angulo teta_2 (Grados)",     ...
          "vel (in/s)");
   legend("R4P","R3P")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))



subplot(3,2,4)
   plot(TETA2,W4)
   plot(TETA2,W5,'r')
   xtitle("Velocidades angulares vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "W (RPM)"); 
   legend("W4","W5")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
   
   
subplot(3,2,5)
   plot(TETA2,R4PP)
   plot(TETA2,R3PP,'r')
   xtitle("Aceleraciones lineales vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "a (in/s^2)"); 
   legend("R4PP","R3PP")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   


subplot(3,2,6)
   plot(TETA2,ALFA4)
   plot(TETA2,ALFA5,'r')
   xtitle("Aceleraciones angulares vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "a (rad/s^2)"); 
   legend("ALFA4","ALFA5")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
      


