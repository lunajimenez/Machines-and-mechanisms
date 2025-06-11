// -----------------------------------------------------------------
// Code name : Solucion al quiz #1 (Corte 2).
// Topic:      Analisis de posiciones, velocidades y aceleraciones.
// Authors:    Karla Sofía Arrieta Arroyo - T00067928
//             Luna Katalina Quintero Jiménez - T00068464
//             Luis Esteban Martínez Urrego - T00068367
// Copyright (C) 2025 
// Date of creation: 28/03/2025

// -----------------------------------------------------------------
//Paso #1: Se borra la pantalla y variables definidas 
// anteriormente
clc
clear

//____________________________________________
//Funcnione utiles
function z=carte(long,teta)
    z=long*[cos(teta);sin(teta)]; 
end

//____________________________________________
// Valores de entrada
r1    = 3*sqrt(2)
r2    = 20.0
teta2 = %pi/2
teta3 = 0
r4_1  = 36.6
r6    = 20.0
teta6 = 30*%pi/180
r7    = 4*sqrt(2)
r3p   = 700
r3pp  = -25000

//_____________________________________________
//Variables globales
//_____________________________________________
//Lazo de posición
function f = lazo1P(x)
      R1   = carte(r1  ,teta1)
      R2   = carte(r2  ,teta2)
      R3   = carte(x(1),teta3)
      R4_1 = carte(r4_1, x(2))
      f = R1+R2+R3-R4_1
endfunction 

function f = lazo2P(x)
      R5   = carte(r1  ,teta1)
      R6   = carte(r6  ,teta6)
      R7   = carte(r7  , x(1))
      R4_2 = carte(x(2),teta4)
      f = R5+R6+R7-R4_2
endfunction 

//_____________________________________________
//Lazos de velocidades
function f = lazo1V(x)
      V1   = carte(r1*x(1),teta1+%pi/2)
      V3   = carte(r3p,teta3)
      V4_1 = carte(r4_1*x(2),teta4+%pi/2)
      f    = V1 + V3 - V4_1
endfunction 

function f = lazo2V(x)
      V5   = carte(r1*w1,teta1+%pi/2)
      V7   = carte(r7*x(1),teta7+%pi/2)
      V4_2 = carte(x(2),teta4)+carte(r4_2*w4,teta4+%pi/2)
      f    = V5 + V7 - V4_2
endfunction 

//_____________________________________________
//Lazos de aceleraciones
function f = lazo1A(x)
      A1   = carte(r1*x(1),teta1+%pi/2)-carte(r1*w1^2,teta1)
      A3   = carte(r3pp,teta3)
      A4_1 = carte(r4_1*x(2),teta4+%pi/2)-carte(r4_1*w4^2,teta4)
      f    = A1 + A3 - A4_1
endfunction 

function f = lazo2A(x)
      A5   = carte(r1*alfa1,teta1+%pi/2)-carte(r1*w1^2,teta1)
      A7   = carte(r7*x(1),teta7+%pi/2)-carte(r7*w7^2,teta7)
      A4_2 = carte(x(2),teta4)+2*carte(r4_2p*w4,teta4+%pi/2)+carte(r4_2*alfa4,teta4+%pi/2)-carte(r4_2*w4^2,teta4)
      f    = A5 + A7 - A4_2
endfunction 

//Valor inicial
x0    = [10 ; 40*%pi/180]
x1    = [20*%pi/180 ;15]
x2    = [50  ;  90]
x3    = [80  ; 300]
x4    = [100 ; 300]
x5    = [250 ; 500]
i     = 1

//Inicio de ciclo para calculos
for teta1 = 0:%pi/40:2*%pi
    //Sol lazo #1 posiciones
    a = fsolve(x0,lazo1P,1e-4)
    r3      = a(1)
    teta4   = a(2)
    
    b = fsolve(x1,lazo2P,1e-4)
    teta7   = b(1)
    r4_2    = b(2)
    
    c = fsolve(x2,lazo1V,1e-4)
    w1      = c(1)
    w4      = c(2)
    
    d = fsolve(x3,lazo2V,1e-4)
    w7      = d(1)
    r4_2p   = d(2)
    
    e = fsolve(x4,lazo1A,1e-4)
    alfa1   = e(1)
    alfa4   = e(2)
    
    f = fsolve(x5,lazo2A,1e-4)
    alfa7   = f(1)
    r4_2pp  = f(2)
    
    //Guarda viables para graficas
    TETA1(i) = teta1*180/%pi

    R3(i)      = a(1)
    TETA4(i)   = a(2)*180/%pi
    
    TETA7(i)   = b(1)*180/%pi
    R4_2(i)    = b(2)

    W1(i)      = c(1)*60/(2*%pi)
    W4(i)      = c(2)*60/(2*%pi)
    
    W7(i)      = d(1)*60/(2*%pi)
    R4_2P(i)   = d(2)

    ALFA1(i)   = e(1)
    ALFA4(i)   = e(2)
    
    ALFA7(i)   = f(1)
    R4_2PP(i)  = f(2)

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

scf(1)
subplot(2,2,1)
   plot(TETA1,R3)
   plot(TETA1,R4_2,'r')
   xtitle("Posiciones lineales vs teta1", ...
          "Angulo teta_1 (Grados)",     ...
          "X (cm)");
   legend("R3","R4_2")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
   
   
subplot(2,2,2)
   plot(TETA1,TETA4)
   plot(TETA1,TETA7,'r')
   xtitle("Posiciones angulares vs teta1", ...
          "Angulo teta_1 (Grados)", ...
          "Angulo (Grados)"); 
   legend("TETA4","TETA7")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))


   
subplot(2,2,3)
   plot(TETA1,R4_2P)
   xtitle("Velocidades lineales vs teta1", ...
          "Angulo teta_1 (Grados)",     ...
          "Vel (cm/s)");
   legend("R4_2P")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
   
   
subplot(2,2,4)
   plot(TETA1,W1)
   xtitle("Velocidades angulares vs teta1", ...
          "Angulo teta_1 (Grados)",     ...
          "W (RPM)");
   legend("W1")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
   

scf(2)
subplot(2,2,1)
   plot(TETA1,W4,'r')
   xtitle("Velocidades angulares vs teta1", ...
          "Angulo teta_1 (Grados)",     ...
          "W (RPM)");
   legend("W4")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
   
   
subplot(2,2,2)
   plot(TETA1,W7,'g')
   xtitle("Velocidades angulares vs teta1", ...
          "Angulo teta_1 (Grados)",     ...
          "W (RPM)");
   legend("W7")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
   
   
subplot(2,2,3)
   plot(TETA1,R4_2PP)
   xtitle("Aceleraciones lineales vs teta1", ...
          "Angulo teta_1 (Grados)",     ...
          "a (cm/s^2)");
   legend("R4_2PP")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
   
   
subplot(2,2,4)
   plot(TETA1,ALFA1)
   xtitle("Aceleraciones angulares vs teta1", ...
          "Angulo teta_1 (Grados)",     ...
          "ALFA (rad/s^2)");
   legend("ALFA1")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))



scf(3)
subplot(2,2,1)
   plot(TETA1,ALFA4,'r')
   xtitle("Aceleraciones angulares vs teta1", ...
          "Angulo teta_1 (Grados)",     ...
          "ALFA (rad/s^2)");
   legend("ALFA4")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))



subplot(2,2,2)
   plot(TETA1,ALFA7,'g')
   xtitle("Aceleraciones angulares vs teta1", ...
          "Angulo teta_1 (Grados)",     ...
          "ALFA (rad/s^2)");
   legend("ALFA7")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
