// ------------------------------------------------------
// Code name : Solucion a posiciones mecanismo de 4 eslabones.
// Topic:      Analisis de posiciones,vel,ace,golpe,fuerzas.
// Author:     Luna K. Quintero J. - T00068464
//             Luis E. Martinez U. - T00068367
// Copyright (C) 2025 
// Date of creation: 10/04/2025
// ------------------------------------------------------

clc
clear

function z=carte(long,teta)
    z=long*[cos(teta);sin(teta)]; 
end

r1=19
r2=5
r3=15
r4=10
//FP = fuerza externa conocida

teta1 = %pi
//Angulos
//CAB=49;
MC=[1 2 5
2 3 6
3 4 0
]
slider=[3 4]//Tamaños
e=4
Tierra=[1 4]

w2  = 25
TAV = [2 3 6]
nv=10

FP = carte(80,330*%pi/180)

//Pesos
Wp2 = 1.5
Wp3 = 7.7
Wp4 = 5.8

//Inercias

I2 = 0.4
I3 = 1.5
I4 = 0.8

//Gravedad (en in)
G = 32.2*12

exec('C:\Users\Administrador\Desktop\Taller1Corte2Mecanismos\Q2v3.sci', -1)

//Calculo de posiciones
function sol=pos1(x)
    R1 = carte(r1,teta1)
    R2 = carte(r2,teta2)
    R3 = carte(r3,x(1))
    R4 = carte(r4,x(2))
    
    sol = R1+R2+R3+R4
    
endfunction

//Calculo de velocidades
function sol=vel1(x)
    V2 = carte(r2*w2  ,teta2+%pi/2)
    V3 = carte(r3*x(1),teta3+%pi/2)
    V4 = carte(r4*x(2),teta4+%pi/2)
    
    sol = V2+V3+V4
    
endfunction

//Calculo de aceleracion
function sol=ace1(x)
    A2 = carte(-r2*w2^2 ,teta2)
    A3 = carte(-r3*w3^2 ,teta3) + carte(r3*x(1) ,teta3+%pi/2)
    A4 = carte(-r4*w4^2 ,teta4) + carte(r4*x(2) ,teta4+%pi/2)
    
    sol = A2+A3+A4
    
endfunction

//Calculo de sacudimiento
function sol=sac1(x)
    J2 = carte(-r2*w2^3 ,teta2+%pi/2)
    J3 = carte(r3*x(1) ,teta3+%pi/2) - carte(3*r3*alfa3*w3 ,teta3)- carte(r3*w3^3,teta3+%pi/2)
    J4 = carte(r4*x(2) ,teta4+%pi/2) - carte(3*r4*alfa4*w4 ,teta4)- carte(r4*w4^3,teta4+%pi/2)
    
    sol = J2+J3+J4
    
endfunction

function F = Fuerzas(Rc1,Rc2,Rc3,Rc4,Rc5,Rc6,Rc7,ac2,ac3,ac4,alfa2,alfa3,alfa4)
    
    A = [Wp2/G*ac2(1);
         Wp2/G*ac2(2)+Wp2;
         I2*alfa2;
         Wp3/G*ac3(1)-FP(1);
         Wp3/G*ac3(2)+Wp3-FP(2);
         I3*alfa3-Rc5(1)*FP(2)+Rc5(2)*FP(1);
         Wp4/G*ac4(1);
         Wp4/G*ac4(2)+Wp4;
         I4*alfa4]
         
    //La matriz nos queda: 
         
    //   F12x       F12y        F23x        F23y        F34x        F34y        F41x        F41y        M
    B = [1           0           1           0           0            0           0           0         0
         0           1           0           1           0            0           0           0         0    
        -Rc1(2)     Rc1(1)     -Rc2(2)      Rc2(1)       0            0           0           0         1
         0           0          -1           0           1            0           0           0         0
         0           0           0          -1           0            1           0           0         0
         0           0          Rc3(2)     -Rc3(1)     -Rc4(2)      Rc4(1)        0           0         0
         0           0           0           0          -1            0           1           0         0
         0           0           0           0           0           -1           0           1         0
         0           0           0           0          Rc6(2)     -Rc6(1)      -Rc7(2)     Rc7(1)      0]
    //A = Bx
    //x = inv(B).A
    F = inv(B)*A
endfunction

//función que calcula las coordenadas de cada punto
function [ptos,tetas]=ba3(teta2,teta3,teta4)
    x = r3*sind(50)/sind(80)
    ptos(1,:)=[0 0]
    ptos(2,:)=carte(r2,teta2)'
    ptos(3,:)=ptos(2,:) + carte(r3,teta3)'
    ptos(4,:)=ptos(3,:) + carte(r4,teta4)'
    ptos(5,:)=carte(r2,teta2+60*%pi/180)'
    ptos(6,:)=ptos(2,:) + carte(x,teta3+50*%pi/180)'
    ptos(7,:)=carte(3,teta2+30*%pi/180)'
    ptos(8,:)=ptos(2,:) + carte(9,teta3+25*%pi/180)'
    ptos(9,:)=ptos(4,:) - carte(r4*0.5,teta4)' //la comilla al final significa q lo traspone, de filas a columnas o de columnas a filas
    
    tetas=[teta2 teta3 teta4]*180/%pi
endfunction


//________________________________Main__________________________________

vi1 = [40 ;270]*%pi/180
vi2 = [40 ;270]*0
vi3 = [40 ;270]*0
vi4 = [40 ;270]*0

j=1

//La matriz del momento solo para FP (debe estar fuera del bucle!)--> Vector 
f2 = zeros(1, ceil(%pi/(5*%pi/180))+1)
    
for teta2=0:5*%pi/180:%pi
    //Sol a pos
    s1=fsolve(vi1,pos1,1e-5)
    teta3 = s1(1)
    teta4 = s1(2)
  
    //Def puntos de animador
    [ptos,tetas]=ba3(teta2,teta3,teta4)
    ptosg(:,:,j)= ptos
    tetasg(:,j) = tetas

    //Sol a vel
    s2=fsolve(vi2,vel1,1e-5)
    w3 = s2(1)
    w4 = s2(2)
    
    //Sol a ace
    s3=fsolve(vi3,ace1,1e-5)
    alfa3 = s3(1)
    alfa4 = s3(2)
    
    //Sol a sacudimiento
    s4=fsolve(vi4,sac1,1e-5)
    phi3 = s4(1)
    phi4 = s4(2)

    //Calculo de aceleracion en cg
    ac2 = carte(-3*w2^2 ,teta2+30*%pi/180)
    ac3 = carte(-r2*w2^2 ,teta2) + carte(-9*w3^2 ,teta3+45*%pi/180) + carte(9*alfa3 ,teta3+135*%pi/180)
    ac4 = carte(-0.5*r4*w4^2 ,teta4-%pi) + carte(0.5*r4*alfa4 ,teta4+%pi/2-%pi)
    
   //Definir distancias
   
   //Eslabón 1
   Rc1 = ptos(1,:) - ptos(7,:)
   Rc2 = ptos(2,:) - ptos(7,:)
   
   //Eslabón 2
   Rc3 = ptos(2,:) - ptos(8,:)
   Rc4 = ptos(3,:) - ptos(8,:)
   Rc5 = ptos(6,:) - ptos(8,:)
   
   //Eslabón 3
 
   Rc6 = ptos(3,:) - ptos(9,:)
   Rc7 = ptos(4,:) - ptos(9,:)  
   
   //El vector F contiene todas las variables para hallar las Fuerzas
   //alfa2 = 0 pq w2 es cte
   
   F = Fuerzas(Rc1,Rc2,Rc3,Rc4,Rc5,Rc6,Rc7,ac2,ac3,ac4,0,alfa3,alfa4)

    //Guardando variables para graficar
    TETA2(j) = teta2*180/%pi
    TETA3(j) = teta3*180/%pi
    TETA4(j) = teta4*180/%pi

    W3(j) = w3*60/(2*%pi)
    W4(j) = w4*60/(2*%pi)
    
    ALFA3(j) = alfa3
    ALFA4(j) = alfa4
    
    PHI3(j) = phi3
    PHI4(j) = phi4
    
    //_________________________________________________________________
    //Procedimiento para el trabajo virtual de FP
    // Recordemos que FP = carte(80,330*%pi/180) 
    
    // Paso 1. Calculo de velocidades en cg de cada eslabón
    vc2 = carte(3*w2, teta2+30*%pi/180+%pi/2)
    vc3 = carte(r2*w2, teta2+%pi/2) + carte(9*w3, teta3+45*%pi/180+%pi/2)
    vc4 = carte(0.5*r4*w4, teta4+%pi/2)
    
    //vc4 = carte(r2*w2, teta2 + %pi/2) + carte(r3*w3, teta3 + %pi/2)+ carte(0.5*r4*w4, teta4 - %pi/2) --> quizá?
    
    //Paso 2. Hacer el producto punto para cada eslabón y sumarlo, sumatoria de m*v*a y de I*w*alfa
    
    suma_mva = (Wp2/G)*(vc2'*ac2) + (Wp3/G)*(vc3'*ac3) + (Wp4/G)*(vc4'*ac4)
    suma_Iwa = I2*w2*0 + I3*w3*alfa3 + I4*w4*alfa4  // alfa2 = 0 porque w2 es constante
    
    //Paso 3. Calcular la velocudad en el punto P
    // P está en el eslabón 3 a 3 unidades con ángulo de 100° desde el punto A
    vp = - carte(r2*w2, teta2+%pi+%pi/2) + carte(9*w3, teta3+45*%pi/180+%pi/2)
    
    //Paso 4. Hacer el la sumatoria de Fp por Vp
    suma_Fpvp = FP'*vp
    
    //Paso 5. Sumar las sumatorias mVa por la de Iwalfa a eso restarle la sumatoria de FpVp y 
    //a eso dividirlo entre el w del eslabón de entrada --> eso es el momento de entrada de FP
    M_trabajo_virtual = (suma_mva + suma_Iwa - suma_Fpvp)/w2
    
    //Ese resultado hacerlo en cada iteración (la iteración va en este mismo ciclo for, donde varía teta2), un vector de momentos M  
    f2(j) = M_trabajo_virtual // Almacenar el resultado para graficarlo
    
    //__________________________________________________________
    
    //Matriz para cada una de las fuerzas calculadas
    f(:,j) = F 
    
    vi1 = s1
    
    //Actualiza posición inicial
    //x1 = a1
    //x2 = a2
    //x3 = a3
    //x4 = a4
    
    //Variable contadora
    j = j +1
end

fn = ["F12x"       "F12y"        "F23x"        "F23y"        "F34x"        "F34y"        "F41x"        "F41y"        "M"]
//ig(Tierra,nv,MC,ptosg,tetasg,e,TAV)

scf
subplot(2,2,1)
   plot(TETA2,TETA3)
   plot(TETA2,TETA4,'r')
   xtitle("Posiciones angulares vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "Angulos (Grados)"); 
   legend("Teta3","Teta4")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))


subplot(2,2,2)
   plot(TETA2,W3)
   plot(TETA2,W4,'r')
   xtitle("Velocidades angulares vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "Velocidades (RPM)"); 
   legend("W3","W4")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

subplot(2,2,3)
   plot(TETA2,ALFA3)
   plot(TETA2,ALFA4,'r')
   xtitle("Aceleraciones angulares vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "Acelraciones (Grados/s2)"); 
   legend("Alfa3","Alfa4")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))


subplot(2,2,4)
   plot(TETA2,PHI3)
   plot(TETA2,PHI4,'r')
   xtitle("Sacudimiento angulares vs teta2", ...
          "Angulo teta_2 (Grados)", ...
          "Scudmiento (Grados/s3)"); 
   legend("Phi3","Phi4")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   
scf
subplot(2,1,1)
    plot(TETA2,f($,:)) //el f que va aquí es la matriz donde se guardaba F
    plot(TETA2,f2,'r--') //Añadido color rojo con línea discontinua (para diferenciar :D)
    xtitle("Momentos vs teta2",...
           "Angulo teta_2 (Grados)",    ...
           "Momento (Lb-in)");
   legend("M", "Momento trabajo virtual")
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))

   
subplot(2,1,2)
N = size(f(:,1))(1)-1
colors = rainbowcolormap(N)

for i=1:1:N
    plot(TETA2, f(i,:), 'color',colors(i,:))
end 
   a = gca()
   a.title.font_size = 4
   a.x_label.font_size = 3
   a.y_label.font_size = 3
   xgrid(color("grey"))
   xtitle("Fuerzas vs teta2",...
           "Angulo teta_2 (Grados)",    ...
           "Fuerza (Lb)");
   legend(fn)

// Calculando los errores: idea --> en la matriz calcular los errores en una nueva columna
// promediar y graficar esos valores. 

// Extraer los momentos de ambos métodos
momento_newton = f($,:);  // Último renglón de la matriz f (momentos calculados con Newton)
momento_virtual = f2;     // Vector de momentos calculados con trabajo virtual

// Calcular el error absoluto entre los dos métodos
error_momento = abs(momento_newton - momento_virtual);

// Calcular el error promedio
error_promedio = mean(error_momento);

// Crear una nueva figura para mostrar el error
scf
plot(TETA2, error_momento)
xtitle("Error entre métodos de Newton y Trabajo Virtual vs teta2", ...
       "Ángulo teta_2 (Grados)", ...
       "Error absoluto (Lb-in)")
xgrid(color("grey"))

// Mostrar una línea horizontal que represente el error promedio
plot(TETA2, error_promedio*ones(1,length(TETA2)), 'r--')
legend("Error absoluto", "Error promedio")

// Imprimir el error promedio
mprintf("\nError absoluto promedio entre los métodos: %.2f Lb-in\n", error_promedio)

// Calcular y mostrar el error porcentual promedio respecto al valor máximo del momento
max_momento = max(abs([max(momento_newton) min(momento_newton) max(momento_virtual) min(momento_virtual)]));
error_porcentual_promedio = 100 * error_promedio / max_momento;
mprintf("Error porcentual promedio respecto al valor máximo: %.2f%%\n", error_porcentual_promedio)

// Si quieres añadir esta columna de error a la matriz f
// Esto extiende la matriz f añadiendo una nueva columna para el error
f_extendida = [f; error_momento];

// La otra sería de los errores porcentuales

// Extraer los momentos de ambos métodos
momento_newton = f($,:);  // Último renglón de la matriz f (momentos calculados con Newton)
momento_virtual = f2;     // Vector de momentos calculados con trabajo virtual

// Calcular el error absoluto entre los dos métodos
error_momento = abs(momento_newton - momento_virtual);

// Calcular el error promedio
error_promedio = mean(error_momento);

// Crear una nueva figura para mostrar el error absoluto
scf(1)
plot(TETA2, error_momento)
xtitle("Error Absoluto entre métodos de Newton y Trabajo Virtual vs teta2", ...
       "Ángulo teta_2 (Grados)", ...
       "Error absoluto (Lb-in)")
xgrid(color("grey"))

// Mostrar una línea horizontal que represente el error promedio
plot(TETA2, error_promedio*ones(1,length(TETA2)), 'r--')
legend("Error absoluto", "Error promedio")

// Imprimir el error promedio
mprintf("\nError absoluto promedio entre los métodos: %.2f Lb-in\n", error_promedio)

// Calcular y mostrar el error porcentual promedio respecto al valor máximo del momento
max_momento = max(abs([max(momento_newton) min(momento_newton) max(momento_virtual) min(momento_virtual)]));
error_porcentual_promedio = 100 * error_promedio / max_momento;
mprintf("Error porcentual promedio respecto al valor máximo: %.2f%%\n", error_porcentual_promedio)

//Trayectoria
