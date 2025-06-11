// -------------------------------------------------------------------------------------------
// Code name : Solucion al taller #1 (Corte 2).
// Topic:      Analisis de posiciones, velocidades, aceleraciones, sacudimiento y animación.
// Authors:    Karla Sofía Arrieta Arroyo - T00067928
//             Luna Katalina Quintero Jiménez - T00068464
// Copyright (C) 2025 
// Date of creation: 30/03/2025

// -------------------------------------------------------------------------------------------
//Paso #1: Se borra la pantalla y variables definidas 
// anteriormente
clc
clear
//____________________________________________
//Función útil :D
function z=carte(long,teta)
    z=long*[cos(teta);sin(teta)]; 
end
//___________________________________________________________________
// Valores de entrada del ejercicio e incógnitas mencionadas
r1    = 9
r2    = 19
teta1 = 90*%pi/2
//teta3 es incógnita
r3_1  = 10
//r3_2 es incógnita
//r4 es incógnita
teta4 = 0*%pi/180
r5 = 36
//teta5 es incógnita
w2 = -30 //a favor de las manecillas (en rad/s)
//r3_2p   es incógnita
//r4p es incógnita
//r4pp es incógnita
//r4ppp es incógnita
//w3 es incógnita
//w5 es incógnita
//alfa5 es incógnita
//r3_2pp es incógnita
//alfa3 es incógnita
//r3_2ppp es incógnita
//phi3 es incógnita
//phi5 es incógnita

//___________________________________________________________________
//Variables globales
//___________________________________________________________________
//Lazo de posición
function f = lazo1P(x)
      R1   = carte(r1  ,teta1)
      R2   = carte(r2  ,teta2)
      R3_2   = carte(x(1),x(2)) //no se conoce magnitud R3 ni su ángulo
      f = R1+R2-R3_2
endfunction 

//las incógnitas van como x(1) y la otra como x(2), 2 máx por lazo
function f = lazo2P(x)
      R3_1   = carte(r3_1  ,teta3)
      R4   = carte(x(1)  ,teta4) //no se conoce magnitud r4
      R5   = carte(r5  , x(2)) //no se conoce ángulo de R5
      f = R3_1-R4-R5
endfunction 

//________________________________________________________________________________________
//Lazos de velocidades
function f = lazo1V(x)
      V2   = carte(r2*w2,teta2+%pi/2) //conocido todo
      V3_2   = carte(x(1),teta3)+carte(r3_2*x(2),teta3+%pi/2) //x(1)=r3_2p, x(2)=w3 
      f    = V2 - V3_2
endfunction 

function f = lazo2V(x)
      V3_1   = carte(r3_1*w3,teta3+%pi/2)
      V4   = carte(x(1),teta4) //r4p desconocido, r4p = x(1)
      V5 = carte(r5*x(2),teta5+%pi/2)//w5 = x(2)
      f  = V3_1 - V4 - V5
endfunction 

//________________________________________________________________________________________
//Lazos de aceleraciones
function f = lazo1A(x)
      A2   = carte(r2*w2*w2,teta2)
      A3_2 = carte(x(1),teta3)+2*carte(r3_2p*w3,teta3+%pi/2)+carte(r3_2*x(2),teta3+%pi/2)-carte(r3_2*w3*w3,teta3) //x(1)=r3_2pp, alfa3 = x(2)
      f    = -A2 - A3_2
endfunction 

function f = lazo2A(x)
      A3_1   = carte(r3_1*alfa3,teta3+%pi/2)-carte(r3_1*w3*w3,teta3) //se conoce todo
      A4   = carte(x(1),teta4) //x(1) = r4pp
      A5 = carte(r5*x(2),teta5+%pi/2)-carte(r5*w5*w5,teta5)//x(2) = alfa5 
      f    = A3_1 - A4 - A5
endfunction 

//________________________________________________________________________________________
//Lazos de sacudimiento (Jerk)
function f = lazo1J(x)
      J2   = carte(r2*w2*w2*w2,teta2+%pi/2)
      J3_2 = carte(x(1),teta3)+3*carte(r3_2pp*w3,teta3+%pi/2)+3*carte(r3_2p*alfa3,teta3+%pi/2)-3*carte(r3_2p*w3*w3,teta3)+carte(r3_2*x(2),teta3+%pi/2)-3*carte(r3_2*alfa3*w3,teta3)-carte(r3_2*w3*w3*w3,teta3+%pi/2) //x(1)=r3_2ppp, phi3 = x(2)
      f    = -J2 - J3_2
endfunction 

function f = lazo2J(x)
      J3_1   = carte(r3_1*phi3,teta3+%pi/2)-3*carte(r3_1*alfa3*w3,teta3)-carte(r3_1*w3*w3*w3,teta3+%pi/2) //se conoce todo, phi3 del lazo anterior
      J4   = carte(x(1),teta4) //x(1) = r4ppp
      J5 = carte(r5*x(2),teta5+%pi/2)-3*carte(r5*alfa5*w5,teta5)-carte(r5*w5*w5*w5,teta5*%pi/2)//x(2) = phi5 
      f    = J3_1 - J4 - J5
endfunction 

//___________________________________________________________________________________________________________________________
//Valores iniciales

//Estos son los valores iniciales para las soluciones iterativas que se realizarán con fsolve(). 
//Cada vector x0-x7 representa una primera aproximación (semilla) para resolver un sistema de ecuaciones correspondiente a:

//x0: Para resolver la posición del lazo 1  
//x1: Para resolver la posición del lazo 2  
//x2: Para velocidades del lazo 1 
//x3: Para velocidades del lazo 2 
//x4: Para aceleraciones del lazo 1 
//x5: Para aceleraciones del lazo 2 
//x6: Para sacudimiento del lazo 1 
//x5: Para sacudimiento del lazo 2 

x0    = [15 ; 30*%pi/180]
x1    = [25 ; 120*%pi/180]
x2    = [50  ; -80]
x3    = [130 ; -100]
x4    = [-150 ; 95]
x5    = [200 ; 105]
x6    = [-400 ; -200]
x7    = [-500 ; 150]
i     = 1

//Inicio de ciclo para calculos. Este ciclo principal itera a través de posiciones angulares del eslabón 1, desde 0 hasta 2pi con incrementos de pi/40

//En cada iteración:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//Resuelve posiciones: Cada fsolve() resuelve un sistema de ecuaciones no lineales, utilizando la función de lazo 
//correspondiente y los valores iniciales (x0 o x1). La tolerancia es 1e-4.

//Resuelve velocidades: aquí resuelve las ecuaciones para encontrar las velocidades angulares w1, w4, w7 y la velocidad lineal r4_2p.

//Resuelve aceleraciones: Finalmente, calcula las aceleraciones angulares alfa1, alfa4, alfa7 y la aceleración lineal r4_2pp.

for teta2 = %pi/2:%pi/40:3/2*%pi
    //Sol lazo #1 posiciones
    a = fsolve(x0,lazo1P,1e-4)
    r3_2      = a(1)
    teta3   = a(2)
    
    b = fsolve(x1,lazo2P,1e-4)
    r4   = b(1)
    teta5    = b(2)
    
    c = fsolve(x2,lazo1V,1e-4)
    r3_2p      = c(1)
    w3      = c(2)
    
    d = fsolve(x3,lazo2V,1e-4)
    r4p  = d(1)
    w5   = d(2)
    
    e = fsolve(x4,lazo1A,1e-4)
    r3_2pp   = e(1)
    alfa3   = e(2)
    
    f = fsolve(x5,lazo2A,1e-4)
    r4pp   = f(1)
    alfa5  = f(2)
    
    g = fsolve(x6,lazo1J,1e-4)
    r3_2ppp = g(1)
    phi3    = g(2)
    
    h = fsolve(x7,lazo2J,1e-4)
    r4ppp = h(1)
    phi5  = h(2)
    
    //Guarda variables para gráficas ---> Almacena resultados en arreglos para generar las gráficas posteriormente
    TETA2(i) = teta2*180/%pi //pasando de rad a grad

    R3_2(i)    = a(1)
    TETA3(i)   = a(2)*180/%pi

    R4(i)      = b(1)
    TETA5(i)   = b(2)*180/%pi

    R3_2P(i)   = c(1)
    W3(i)      = c(2)*60/(2*%pi)
    
    R4P(i)     = d(1)
    W5(i)      = d(2)*60/(2*%pi)
    
    R3_2PP(i)  = e(1)
    ALFA3(i)   = e(2)
    
    R4PP(i)    = f(1)
    ALFA5(i)   = f(2)
    
    R3_2PPP(i) = g(1)
    PHI3(i)     = g(2)
    
    R4PPP(i)   = h(1)
    PHI5(i)     = h(2)

    //Actualiza posicion inicial --> actualiza valores iniciales para la siguiente iteración
    //Esto es clave para la eficiencia: usa la solución actual como punto de partida para la siguiente iteración, lo que normalmente lleva a una convergencia más rápida.
    x0 = a
    x1 = b
    x2 = c
    x3 = d
    x4 = e
    x5 = f
    x6 = g
    x7 = h
    
    //Variable contadora
    i  = i+1
end

// El algoritmo utiliza Newton-Raphson (implementado en fsolve()) para resolver los sistemas no lineales en cada paso.
// La estrategia de utilizar la solución anterior como semilla para la siguiente iteración es muy eficiente, porque las posiciones,
// velocidades y aceleraciones cambian de manera continua.

//_____________________________________________________________________________________________________________________
//Resultados
//Para cada lazo, se grafican las posiciones, velocidades y aceleraciones en función de teta2 (variable en un rango)

//Poner el TETA que oscila, en este caso es el TETA2.
//Graficamos lo que queramos :D

//Gráficas de las posiciones

scf(1)
subplot(2,2,1)
   plot(TETA2,TETA3)
   plot(TETA2,TETA5,'r')
   xtitle("Posicion angulares vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "Angulos (Grados)"); 
   legend("TETA3","TETA5")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))


subplot(2,2,2)
   plot(TETA2,R3_2)
   plot(TETA2,R4,'r')
   xtitle("Posicion lineales vs teta2", ...
          "Angulo teta_2 (Grados)",     ...
          "X (cm)");
   legend("R3_2","R4")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))



subplot(2,2,3)
   plot(TETA2,R3_2P)
   plot(TETA2,R4P,'r')
   xtitle("Velocidades lineales vs teta2", ...
          "Angulo teta_2 (Grados)",     ...
          "Vel (cm/s)");
   legend("R3_2P","R4P")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))



subplot(2,2,4)
   plot(TETA2,W3)
   plot(TETA2,W5,'r')
   xtitle("Velocidades angulares vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "W (RPM)"); 
   legend("W3","W5")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))



scf(2)
subplot(2,2,1)
   plot(TETA2,R3_2PP)
   plot(TETA2,R4PP,'r')
   xtitle("Aceleraciones lineales vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "A (cm/s^2)"); 
   legend("R3_2PP","R4PP")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))



subplot(2,2,2)
   plot(TETA2,ALFA3)
   plot(TETA2,ALFA5,'r')
   xtitle("Aceleraciones angulares vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "ALFA (rad/s^2)"); 
   legend("ALFA3","ALFA5")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))



subplot(2,2,3)
   plot(TETA2,R3_2PPP)
   plot(TETA2,R4PPP,'r')
   xtitle("Sacudimientos lineales vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "J (Jerks)"); 
   legend("R3_2PPP","R4PPP")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))



subplot(2,2,4)
   plot(TETA2,PHI3)
   plot(TETA2,PHI5,'r')
   xtitle("Sacudimientos angulares vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "J (Jerks)"); 
   legend("PHI3","PHI5")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
