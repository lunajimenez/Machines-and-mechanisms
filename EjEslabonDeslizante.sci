// -----------------------------------------------------------------
// Code name : EjEslabonDeslizante
// Topic:      Análisis y animador de mecanismo con eslabón deslizante. 
// Authors:     Luna Katalina Quintero Jiménez - T00068464
// Copyright (C) 2025 
// Date of creation: 12/04/2025
// -----------------------------------------------------------------

clc
clear

//____________________________________________
//Funcniones útiles
function z=carte(long,teta)
    z=long*[cos(teta);sin(teta)]; 
end



//____________________________________________
// Valores de entrada
r1    = 9.0
teta1 = %pi/2
r2    = 19.0
r3_1  = 10.0 
teta4 = 0
r5    = 36.0
r6    = 30
w2    = -30

//____________________________________________
//Angulos
MC=[2 4 0
1 3 0
1 4 0
1 6 0
3 5 0
4 0 0
5 0 0]
slider=10*[7/(20) 4/(20)]//Tama;os
e=[4]
Tierra=[1 2]
nv=10
exec('C:\Users\Administrador\Desktop\Taller1Corte2Mecanismos\Q2v3.sci', -1)
//_____________________________________________
//Variables globales
//_____________________________________________
//Lazos de posiciones
function f = lazo1P(x)
      R1   = carte(r1  ,teta1)
      R2   = carte(r2  ,teta2)
      R3_2 = carte(x(1), x(2))
      f = R1+R2-R3_2
endfunction 

function f = lazo2P(x)
      R3_1 = carte(r3_1 ,teta3)
      R4   = carte(x(1) ,teta4)
      R5   = carte(r5   , x(2))
      f = R3_1-R4-R5
endfunction 

//_____________________________________________
//Lazos de velocidades
function f = lazo1V(x)
      V2   = carte(r2*w2,teta2+%pi/2)
      V3_2 = carte(x(1),teta3)+carte(r3_2*x(2),teta3+%pi/2)
      f    = V2 - V3_2
endfunction

function f = lazo2V(x)
      V3_1 = carte(r3_1*w3,teta3+%pi/2)
      V4   = carte(x(1),teta4)
      V5   = carte(r5*x(2),teta5+%pi/2)
      f = V3_1 - V4 - V5
endfunction

//_____________________________________________
//Lazos de aceleraciones
function f = lazo1A(x)
      A2   = carte(r2*w2^2,teta2)
      A3_2 = carte(x(1),teta3)+2*carte(r3_2p*w3,teta3+%pi/2)+carte(r3_2*x(2),teta3+%pi/2)-carte(r3_2*w3^2,teta3)
      f    = -A2 - A3_2
endfunction

function f = lazo2A(x)
      A3_1 = carte(r3_1*alfa3,teta3+%pi/2)-carte(r3_1*w3^2,teta3)
      A4   = carte(x(1),teta4)
      A5   = carte(r5*x(2),teta5+%pi/2)-carte(r5*w5^2,teta5)
      f = A3_1 - A4 - A5
endfunction

//_____________________________________________
//Lazos de sacudimientos
function f = lazo1J(x)
      J2   = carte(r2*w2^3,teta2+%pi/2)
      J3_2 = carte(x(1),teta3)+3*carte(r3_2pp*w3,teta3+%pi/2)+3*carte(r3_2p*alfa3,teta3+%pi/2)-3*carte(r3_2p*w3^2,teta3)+carte(r3_2*x(2),teta3+%pi/2)-3*carte(r3_2*alfa3*w3,teta3)-carte(r3_2*w3^3,teta3+%pi/2)
      f    = -J2 - J3_2
endfunction

function f = lazo2J(x)
      J3_1 = carte(r3_1*fi3,teta3+%pi/2)-3*carte(r3_1*alfa3*w3,teta3)-carte(r3_1*w3^3,teta3+%pi/2)
      J4   = carte(x(1),teta4)
      J5   = carte(r5*x(2),teta5+%pi/2)-3*carte(r5*alfa5*w5,teta5)-carte(r5*w5^3,teta5+%pi/2)
      f    = J3_1 - J4 - J5 
endfunction

//_____________________________________________
function [ptos,tetas]=ba3(r3_2,teta3,r4,teta5)
    ptos(1,:)=[0 0]
    ptos(2,:)=carte(r1,teta1)
    ptos(3,:)=carte(r3_1,teta3)'
    ptos(4,:)=carte(r3_2,teta3)'
    ptos(5,:)=carte(r4,teta4)'
    ptos(6,:)=carte(r6,teta3)'
    tetas=[teta2 teta3 teta3 teta3 teta5 teta3 0]*180/%pi
endfunction

//Valor inicial
x0    = [15 ; 30*%pi/180]
x1    = [25 ; 120*%pi/180]
x2    = [50  ; -80]
x3    = [130 ; -100]
x4    = [-150 ; 95]
x5    = [200 ; 105]
x6    = [-400 ; -200]
x7    = [-500 ; 150]
j     = 1

//Inicio de ciclo para calculos
for teta2 = %pi/2:%pi/40:3/2*%pi
    //Sol lazo #1 posiciones
    a = fsolve(x0,lazo1P,1e-4)
    r3_2    = a(1)
    teta3   = a(2)
    
    b = fsolve(x1,lazo2P,1e-4)
    r4      = b(1)
    teta5   = b(2)
    
    c = fsolve(x2,lazo1V,1e-4)
    r3_2p   = c(1)
    w3      = c(2)
    
    d = fsolve(x3,lazo2V,1e-4)
    r4p     = d(1)
    w5      = d(2)
    
    t = fsolve(x4,lazo1A,1e-4)
    r3_2pp  = t(1)
    alfa3   = t(2)
    
    f = fsolve(x5,lazo2A,1e-4)
    r4pp    = f(1)
    alfa5   = f(2)
    
    g = fsolve(x6,lazo1J,1e-4)
    r3_2ppp = g(1)
    fi3     = g(2)
    
    h = fsolve(x7,lazo2J,1e-4)
    r4ppp   = h(1)
    fi5     = h(2)
    
    //Guarda viables para graficas
    TETA2(j) = teta2*180/%pi

    R3_2(j)    = a(1)
    TETA3(j)   = a(2)*180/%pi

    R4(j)      = b(1)
    TETA5(j)   = b(2)*180/%pi

    R3_2P(j)   = c(1)
    W3(j)      = c(2)*60/(2*%pi)
    
    R4P(j)     = d(1)
    W5(j)      = d(2)*60/(2*%pi)
    
    R3_2PP(j)  = t(1)
    ALFA3(j)   = t(2)
    
    R4PP(j)    = f(1)
    ALFA5(j)   = f(2)
    
    R3_2PPP(j) = g(1)
    FI3(j)     = g(2)
    
    R4PPP(j)   = h(1)
    FI5(j)     = h(2)

    //Actualiza posicion inicial
    x0 = a
    x1 = b
    x2 = c
    x3 = d
    x4 = t
    x5 = f
    x6 = g
    x7 = h
    
    [ptos,tetas]=ba3(a(1),a(2),b(1),b(2))
    ptosg(:,:,j)=ptos
    tetasg(:,j)=tetas
    p4x(j)=ptos(4,1)
    p4y(j)=ptos(4,2)
    
    //Variable contadora
    j  = j+1
end

ig(Tierra,nv,MC,ptosg,tetasg,e,[1 2 3 4 5 6])

//__________________________________________________________
//Resultados
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
   xtitle("Trayectoria", ...
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
   plot(TETA2,FI3)
   plot(TETA2,FI5,'r')
   xtitle("Sacudimientos angulares vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "J (Jerks)"); 
   legend("FI3","FI5")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

scf()
plot(p4x,p4y)
   xtitle("Leva y su trayectoria", ...
          "P4x", ...
          "P4y"); 
    legend("Trayectoria")
    //a = gca()
    a.title.font_size = 4
    a.x_label.font_size = 3
    a.y_label.font_size = 3
    xgrid(color("grey"))
//Trayectoria
