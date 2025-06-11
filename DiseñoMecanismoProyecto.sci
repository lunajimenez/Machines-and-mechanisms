// ------------------------------------------------------
// Code name : Proyecto de mecanismos.
// Topic:      Analisis de posiciones,vel,ace,golpe.
// Author:     Karla Sofía Arrieta Arroyo - T00067928
//             Yair Beleño Rivera - T00078197
//             Luna Katalina Quintero Jiménez - T00068464
//             Juan Manuel Albarracín Caballero - T00078499
//             Said Stiven Camargo Nobles - T00083109
// Copyright (C) 2025 
// Date of creation: 25/05/2025
// ------------------------------------------------------

clc
clear

function z=carte(long,teta)
    z=long*[cos(teta);sin(teta)]; 
end

//Datos iniciales
r1=6.4*5
r2=1*5
r3=8.3*5
r4=4.3*5
r5=4*5
r6=10.636*5
r7=4.3*5
r8=4*5
r9=10.636*5
r10=4*5
r11=4*5
teta1=85*%pi/180
teta7=0
r4_2=3*5

//Matriz para los eslabones
MC=[1 2 0
    2 3 0
    4 5 0
    5 6 0
    5 7 0
    6 8 0
    7 8 0
    6 9 0
    7 9 0]

slider=[3 2]//Tamaño de bloques deslizantes/collarines
e=3 //Tamaño de juntas
Tierra=[1 4 8] //Enlace de tierra
Angulorecorrido=360*2 //Angulo recorrido por el valor de entrada
w2=10.4719 //velocidad para la animacion del mecanismo
l=[0 0 0 0 0 0] //Valores iniciales
nv=10 //Número de vueltas
TAV=[5 6 7 9] //Trayectorias a ver

exec('C:\Users\Administrador\Desktop\Taller1Corte2Mecanismos\Q2v3.sci', -1)

//Calculo de posiciones
function sol=pos1(x)
    R1 = carte(r1,teta1)
    R2 = carte(r2,teta2)
    R3 = carte(r3,x(1))
    R4_2 = carte(r4_2,x(2))
    
    sol = R1-R2-R3+R4_2
    
endfunction

function sol=pos2(x)
    R4 = carte(r4,teta4)
    R5 = carte(r5,x(1))
    R6 = carte(r6,x(2))
    R7 = carte(r7,teta7)
    
    sol = R4-R5+R6+R7
    
endfunction

function sol=pos3(x)
    R4 = carte(r4,teta4)
    R7 = carte(r7,teta7)
    R8 = carte(r8,x(1))
    R9 = carte(r9,x(2))
    
    sol = R4+R7+R8-R9
    
endfunction

function sol=pos4(x)
    R6  = carte(r6,teta6)
    R9  = carte(r9,teta9)
    R10 = carte(r10,x(1))
    R11 = carte(r11,x(2))
    
    sol = R6+R9-R10-R11
    
endfunction

//Calculo de velocidades
function sol=vel1(x)
    V2 = carte(-r2*w2  ,teta2+%pi/2)
    V3 = carte(r3*x(1),teta3+%pi/2)
    V4_2 = carte(r4_2*x(2),teta4+%pi/2)
    
    sol = V2-V3+V4_2
    
endfunction

function sol=vel2(x)
    V4 = carte(r4*w4  ,teta4+%pi/2)
    V5 = carte(r5*x(1),teta5+%pi/2)
    V6 = carte(r6*x(2),teta6+%pi/2)
    
    sol = V4-V5+V6
    
endfunction

function sol=vel3(x)
    V4 = carte(r4*w4  ,teta4+%pi/2)
    V8 = carte(r8*x(1),teta8+%pi/2)
    V9 = carte(r9*x(2),teta9+%pi/2)
    
    sol = V4+V8-V9
    
endfunction

function sol=vel4(x)
    V6  = carte(r6*w6  ,teta6+%pi/2)
    V9  = carte(r9*w9  ,teta9+%pi/2)
    V10 = carte(r10*x(1),teta10+%pi/2)
    V11 = carte(r11*x(2),teta11+%pi/2)
    
    sol = V6+V9-V10-V11
    
endfunction

//Calculo de aceleracion
function sol=ace1(x)
    A2 = carte(r2*w2^2 ,teta2)
    A3 = carte(r3*x(1) ,teta3+%pi/2) - carte(r3*w3^2 ,teta3)
    A4_2 = carte(r4_2*x(2) ,teta4+%pi/2) - carte(r4_2*w4^2 ,teta4) 
    
    sol = A2-A3+A4_2
    
endfunction

function sol=ace2(x)
    A4 = carte(r4*alfa4 ,teta4+%pi/2) - carte(r4*w4^2 ,teta4)
    A5 = carte(r5*x(1) ,teta5+%pi/2) - carte(r5*w5^2 ,teta5)
    A6 = carte(r6*x(2) ,teta6+%pi/2) - carte(r6*w6^2 ,teta6) 
    
    sol = A4-A5+A6
    
endfunction

function sol=ace3(x)
    A4 = carte(r4*alfa4 ,teta4+%pi/2) - carte(r4*w4^2 ,teta4)
    A8 = carte(r8*x(1) ,teta8+%pi/2) - carte(r8*w8^2 ,teta8)
    A9 = carte(r9*x(2) ,teta9+%pi/2) - carte(r9*w9^2 ,teta9) 
    
    sol = A4+A8-A9
    
endfunction

function sol=ace4(x)
    A6  = carte(r6*alfa6 ,teta6+%pi/2) - carte(r6*w6^2 ,teta6)
    A9  = carte(r9*alfa9 ,teta9+%pi/2) - carte(r9*w9^2 ,teta9)
    A10 = carte(r10*x(1) ,teta10+%pi/2) - carte(r10*w10^2 ,teta10)
    A11 = carte(r11*x(2) ,teta11+%pi/2) - carte(r11*w11^2 ,teta11) 
    
    sol = A6+A9-A10-A11
    
endfunction

//Calculo de sacudimiento
function sol=sac1(x)
    J2 = carte(r2*w2^3 ,teta2+%pi/2)
    J3 = carte(r3*x(1) ,teta3+%pi/2) - carte(3*r3*alfa3*w3 ,teta3)- carte(r3*w3^3,teta3+%pi/2)
    J4_2 = carte(r4_2*x(2) ,teta4+%pi/2) - carte(3*r4_2*alfa4*w4 ,teta4)- carte(r4_2*w4^3,teta4+%pi/2)
    
    sol = J2-J3+J4_2
    
endfunction

function sol=sac2(x)
    J4 = carte(r4*phi4 ,teta4+%pi/2)- carte(3*r4*alfa4*w4 ,teta4) - carte(r4*w4^3 ,teta4+%pi/2)
    J5 = carte(r5*x(1) ,teta5+%pi/2) - carte(3*r5*alfa5*w5 ,teta5)- carte(r5*w5^3,teta5+%pi/2)
    J6 = carte(r6*x(2) ,teta6+%pi/2) - carte(3*r6*alfa6*w6 ,teta6)- carte(r6*w6^3,teta6+%pi/2)
    
    sol = J4-J5+J6
    
endfunction

function sol=sac3(x)
    J4 = carte(r4*phi4 ,teta4+%pi/2)- carte(3*r4*alfa4*w4 ,teta4) - carte(r4*w4^3 ,teta4+%pi/2)
    J8 = carte(r8*x(1) ,teta8+%pi/2) - carte(3*r8*alfa8*w8 ,teta8)- carte(r8*w8^3,teta8+%pi/2)
    J9 = carte(r9*x(2) ,teta9+%pi/2) - carte(3*r9*alfa9*w9 ,teta9)- carte(r9*w9^3,teta9+%pi/2)
    
    sol = J4+J8-J9
    
endfunction

function sol=sac4(x)
    J6  = carte(r6*phi6 ,teta6+%pi/2)- carte(3*r6*alfa6*w6 ,teta6) - carte(r6*w6^3 ,teta6+%pi/2)
    J9  = carte(r9*phi9 ,teta9+%pi/2)- carte(3*r9*alfa9*w9 ,teta9) - carte(r9*w9^3 ,teta9+%pi/2)
    J10 = carte(r10*x(1) ,teta10+%pi/2) - carte(3*r10*alfa10*w10 ,teta10)- carte(r10*w10^3,teta10+%pi/2)
    J11 = carte(r11*x(2) ,teta11+%pi/2) - carte(3*r11*alfa11*w11 ,teta11)- carte(r11*w11^3,teta11+%pi/2)
    
    sol = J6+J9-J10-J11
    
endfunction

//Función para definir la ubicacion de las juntas
function [ptos,tetas]=ba3(teta3,teta4,teta5,teta6,teta8,teta9)
    ptos(1,:)=[0 0]
    ptos(2,:)=carte(r2,teta2)'
    ptos(3,:)=carte(r2,teta2)'+carte(r3,teta3)'
    ptos(4,:)=carte(r1,teta1)'
    ptos(5,:)=ptos(4,:)+carte(r4,teta4)'
    ptos(6,:)=ptos(5,:)-carte(r5,teta5)'
    ptos(7,:)=ptos(5,:)+carte(r8,teta8)'
    ptos(8,:)=ptos(4,:)-carte(r7,teta7)'
    ptos(9,:)=ptos(6,:)+carte(r10,teta8)'
    tetas=[teta2 teta3 teta4 teta5 teta6 teta8 teta9 ]
endfunction

//________________________________Main__________________________________

vi1 = [40 ;70]*%pi/180
vi2 = [100 ;140]*%pi/180
vi3 = [60 ;40]*%pi/180
vi4 = [40 ;270]*0
vi5 = [40 ;270]*0
vi6 = [40 ;270]*0
vi7 = [40 ;270]*0
vi8 = [40 ;270]*0
vi9 = [40 ;270]*0
vi10 = [40 ;270]*0
vi11 = [40 ;270]*0
vi12 = [40 ;270]*0
vi13 = [40 ;100]*%pi/180
vi14 = [40 ;270]*0
vi15 = [40 ;270]*0
vi16 = [40 ;270]*0

j=1
for teta2=0:5*%pi/180:2*%pi
    t=teta2/w2
    
    //Sol a pos
    s1=fsolve(vi1,pos1,1e-5)
    teta3 = s1(1)
    teta4 = s1(2)
    
    s2=fsolve(vi2,pos2,1e-5)
    teta5 = s2(1)
    teta6 = s2(2)
    
    s3=fsolve(vi3,pos3,1e-5)
    teta8 = s3(1)
    teta9 = s3(2)
  
    //Def puntos de animador
    [ptos,tetas]=ba3(teta3,teta4,teta5,teta6,teta8,teta9)
    ptosg(:,:,j)= ptos
    tetasg(:,j) = tetas

    //Sol a vel
    s4=fsolve(vi4,vel1,1e-5)
    w3 = s4(1)
    w4 = s4(2)
    
    s5=fsolve(vi5,vel2,1e-5)
    w5 = s5(1)
    w6 = s5(2)
    
    s6=fsolve(vi6,vel3,1e-5)
    w8 = s6(1)
    w9 = s6(2)
    
    //Sol a ace
    s7=fsolve(vi7,ace1,1e-5)
    alfa3 = s7(1)
    alfa4 = s7(2)
   
    s8=fsolve(vi8,ace2,1e-5)
    alfa5 = s8(1)
    alfa6 = s8(2)
    
    s9=fsolve(vi9,ace3,1e-5)
    alfa8 = s9(1)
    alfa9 = s9(2)
    
    //Sol a sacudimiento
    s10=fsolve(vi10,sac1,1e-5)
    phi3 = s10(1)
    phi4 = s10(2)
    
    s11=fsolve(vi11,sac2,1e-5)
    phi5 = s11(1)
    phi6 = s11(2)

    s12=fsolve(vi12,sac3,1e-5)
    phi8 = s12(1)
    phi9 = s12(2)
    
    //Sol a lazo adicional para acopladores
    s13=fsolve(vi13,pos4,1e-5)
    teta10 = s13(1)
    teta11 = s13(2)
    
    s14=fsolve(vi14,vel4,1e-5)
    w10 = s14(1)
    w11 = s14(2)
    
    s15=fsolve(vi15,ace4,1e-5)
    alfa10 = s15(1)
    alfa11 = s15(2)
    
    s16=fsolve(vi16,sac4,1e-5)
    phi10 = s16(1)
    phi11 = s16(2)
    
    //Cálculo en el punto de interés 
    p9 = carte(r1,teta1) + carte(r4,teta4) - carte(r5,teta5) + carte(r10,teta10)
    vl9 = carte(r4*w4  ,teta4+%pi/2) - carte(r5*w5,teta5+%pi/2) + carte(r10*w10,teta10+%pi/2)
    ac9 = carte(r4*alfa4 ,teta4+%pi/2) - carte(r4*w4^2 ,teta4 )-(carte(r5*alfa5 ,teta5+%pi/2) - carte(r5*w5^2 ,teta5))+carte(r10*alfa10,teta10+%pi/2) - carte(r10*w10^2 ,teta10)
    sa9 = carte(r4*phi4 ,teta4+%pi/2) - carte(3*r4*alfa4*w4 ,teta4) - carte(r4*w4^3 ,teta4+%pi/2) - (carte(r5*phi5 ,teta5+%pi/2) - carte(3*r5*alfa5*w5 ,teta5)- carte(r5*w5^3,teta5+%pi/2)) + carte(r10*phi10 ,teta10+%pi/2) - carte(3*r10*alfa10*w10 ,teta10)- carte(r10*w10^3,teta10+%pi/2)
    
    //Guardando variables
    TETA2(j) = teta2*180/%pi
    T(j)     = t
    TETA3(j) = teta3*180/%pi
    TETA4(j) = teta4*180/%pi
    TETA5(j) = teta5*180/%pi
    TETA6(j) = teta6*180/%pi
    TETA8(j) = teta8*180/%pi
    TETA9(j) = teta9*180/%pi
    TETA10(j) = teta10*180/%pi
    TETA11(j) = teta11*180/%pi

    W3(j) = w3*60/(2*%pi)
    W4(j) = w4*60/(2*%pi)
    W5(j) = w5*60/(2*%pi)
    W6(j) = w6*60/(2*%pi)
    W8(j) = w8*60/(2*%pi)
    W9(j) = w9*60/(2*%pi)
    W10(j) = w10*60/(2*%pi)
    W11(j) = w11*60/(2*%pi)
    
    ALFA3(j) = alfa3
    ALFA4(j) = alfa4
    ALFA5(j) = alfa5
    ALFA6(j) = alfa6
    ALFA8(j) = alfa8
    ALFA9(j) = alfa9
    ALFA10(j) = alfa10
    ALFA11(j) = alfa11
    
    PHI3(j) = phi3
    PHI4(j) = phi4
    PHI5(j) = phi5
    PHI6(j) = phi6
    PHI8(j) = phi8
    PHI9(j) = phi9
    PHI10(j) = phi10
    PHI11(j) = phi11
    
    P9(:, j) = p9;
    VL9(:, j) = vl9;
    AC9(:, j) = ac9;
    SA9(:, j) = sa9;
    
    mag_P9 = sqrt(P9(1, :).^2 + P9(2, :).^2); 
    mag_VL9 = sqrt(VL9(1, :).^2 + VL9(2, :).^2);
    mag_AC9 = sqrt(AC9(1, :).^2 + AC9(2, :).^2);
    mag_SA9 = sqrt(SA9(1, :).^2 + SA9(2, :).^2);
    
    vi1 = s1
    vi2 = s2
    vi3 = s3
    vi4 = s4
    vi5 = s5
    vi6 = s6
    vi7 = s7
    vi8 = s8
    vi9 = s9
    vi10 = s10
    vi11 = s11
    vi12 = s12
    vi13 = s13
    vi14 = s14
    vi15 = s15
    vi16 = s16
    
    j = j +1
end

ig(Tierra,nv,MC,ptosg,tetasg,e,TAV)

scf
subplot(2,2,1)
   plot(T,TETA3)
   plot(T,TETA4,'r')
   xtitle("Posiciones angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Angulos (Grados)"); 
   legend("Teta3","Teta4")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
subplot(2,2,2)
   plot(T,TETA5)
   plot(T,TETA6,'r')
   xtitle("Posiciones angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Angulos (Grados)"); 
   legend("Teta5","Teta6")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
subplot(2,2,3)
   plot(T,TETA8)
   plot(T,TETA9,'r')
   xtitle("Posiciones angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Angulos (Grados)"); 
   legend("Teta8","Teta9")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

subplot(2,2,4)
   plot(T,TETA10)
   plot(T,TETA11,'r')
   xtitle("Posiciones angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Angulos (Grados)"); 
   legend("Teta10","Teta11")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
scf
subplot(2,2,1)
   plot(T,W3)
   plot(T,W4,'r')
   xtitle("Velocidades angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Velocidades (RPM)"); 
   legend("W3","W4")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
subplot(2,2,2)
   plot(T,W5)
   plot(T,W6,'r')
   xtitle("Velocidades angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Velocidades (RPM)"); 
   legend("W5","W6")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
subplot(2,2,3)
   plot(T,W8)
   plot(T,W9,'r')
   xtitle("Velocidades angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Velocidades (RPM)"); 
   legend("W8","W9")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

subplot(2,2,4)
   plot(T,W10)
   plot(T,W11,'r')
   xtitle("Velocidades angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Velocidades (RPM)"); 
   legend("W10","W11")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

scf
subplot(2,2,1)
   plot(T,ALFA3)
   plot(T,ALFA4,'r')
   xtitle("Aceleraciones angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Aceleraciones (rad/s2)"); 
   legend("Alfa3","Alfa4")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

subplot(2,2,2)
   plot(T,ALFA5)
   plot(T,ALFA6,'r')
   xtitle("Aceleraciones angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Aceleraciones (rad/s2)"); 
   legend("Alfa5","Alfa6")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
subplot(2,2,3)
   plot(T,ALFA8)
   plot(T,ALFA9,'r')
   xtitle("Aceleraciones angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Aceleraciones (rad/s2)"); 
   legend("Alfa8","Alfa9")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

subplot(2,2,4)
   plot(T,ALFA10)
   plot(T,ALFA11,'r')
   xtitle("Aceleraciones angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Aceleraciones (rad/s2)"); 
   legend("Alfa10","Alfa11")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
scf
subplot(2,2,1)
   plot(T,PHI3)
   plot(T,PHI4,'r')
   xtitle("Sacudimientos angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Sacudmiento (rad/s3)"); 
   legend("Phi3","Phi4")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

subplot(2,2,2)
   plot(T,PHI5)
   plot(T,PHI6,'r')
   xtitle("Sacudimientos angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Sacudmiento (rad/s3)"); 
   legend("Phi5","Phi6")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

subplot(2,2,3)
   plot(T,PHI8)
   plot(T,PHI9,'r')
   xtitle("Sacudimientos angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Sacudmiento (rad/s3)"); 
   legend("Phi8","Phi9")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
subplot(2,2,4)
   plot(T,PHI10)
   plot(T,PHI11,'r')
   xtitle("Sacudimientos angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Sacudmiento (rad/s3)"); 
   legend("Phi10","Phi11")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
scf
subplot(2,2,1)
   plot(T,mag_P9)
   xtitle("Posiciones lineales vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Angulos (Grados)"); 
   legend("mag_P9")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

subplot(2,2,2)
   plot(T,mag_VL9)
   xtitle("Velocidades lineales vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Velocidades (RPM)"); 
   legend("mag_VL9")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

subplot(2,2,3)
   plot(T,mag_AC9)
   xtitle("Aceleraciones lineales vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Aceleraciones (rad/s2)"); 
   legend("mag_AC9")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

subplot(2,2,4)


   plot(T,mag_SA9)
   xtitle("Sacudimientos lineales vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Sacudmiento (rad/s3)"); 
   legend("mag_SA9")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
scf
subplot(2,2,1)
   plot(T,P9)
   xtitle("Posiciones angulares vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Distancia x (cm)"); 
   legend("P9_x","P9_y")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

subplot(2,2,2)
   plot(T,VL9)
   xtitle("Velocidades lineales vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Velocidades (cm/s)"); 
   legend("VL9_x","VL9_y")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

subplot(2,2,3)
   plot(T,AC9)
   xtitle("Aceleraciones lineales vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Aceleraciones (cm/s2)"); 
   legend("AC9_x","AC9_y")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

subplot(2,2,4)
   plot(T,SA9)
   xtitle("Sacudimientos lineales vs Tiempo", ...
          "Tiempo t (Segundos)", ...
          "Sacudmiento (cm/s3)"); 
   legend("SA9_x","SA9_y")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
