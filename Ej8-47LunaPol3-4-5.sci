// -----------------------------------------------------------------
// Code name:         Cam Design with Polynomial 3-4-5 Function. 
// Topic:             Design of Machinery
// sub-topic:         Cam Design Problem 8-47
// Author:            Luna K. Quintero J.
// Date:              05/05/20255
// -----------------------------------------------------------------
clc
clear

function graficador(x,y,ang,T,P)
    subplot(P)
    
    a=get("current_axes") ;   t=a.title;
    type(a.title)
    plot(x,y)
    
    a.x_label ;   a.y_label
    xtitle(T(1),T(2),T(3))
    
    t.font_size=3;  t.font_style=4; 
    x_label=a.x_label;  x_label.font_style= 4; x_label.font_size=2
    y_label=a.y_label;  y_label.font_style= 4; y_label.font_size=2
    
    xx=[ang' ang']
    yy=[min(y) max(y)]
    for i=1:max(size(ang))
        plot(xx(i,:),yy,'r')
    end
    
    a=get("current_axes")//get the handle of the newly created axes
    a.axes_visible="on"; // makes the axes visible
    a.font_size=3; 
    a.sub_tics=[5,5];
    a.box="off";
    a.x_location="origin"

    a.x_ticks = tlist(["ticks" "locations", "labels"], ang', string(ang'))
endfunction

// Función Polinomio 3-4-5
function [s,v,a,j]=Func345(theta,Beta,h,tipo)
    if tipo == "subida" then
        c0 = 0; c1 = 0; c2 = 0; 
        c3 = 10*h; c4 = -15*h; c5 = 6*h;
    else // bajada
        c0 = h; c1 = 0; c2 = 0; 
        c3 = -10*h; c4 = 15*h; c5 = -6*h;
    end
    
    s = c0 + c1*(theta/Beta) + c2*(theta/Beta)^2 + c3*(theta/Beta)^3 + c4*(theta/Beta)^4 + c5*(theta/Beta)^5
    v = (1/Beta)*(c1 + 2*c2*(theta/Beta) + 3*c3*(theta/Beta)^2 + 4*c4*(theta/Beta)^3 + 5*c5*(theta/Beta)^4)
    a = (1/Beta^2)*(2*c2 + 6*c3*(theta/Beta) + 12*c4*(theta/Beta)^2 + 20*c5*(theta/Beta)^3)
    j = (1/Beta^3)*(6*c3 + 24*c4*(theta/Beta) + 60*c5*(theta/Beta)^2)
endfunction

//_____________________________________________________________________________
// Datos de entrada para el Problema 8-47
h = 65        // Desplazamiento total en mm
t_ciclo = 2   // Tiempo del ciclo en segundos
omega = 2*%pi/t_ciclo    // Velocidad angular rad/s

// Datos de entrada para programa de movimiento
PdM=["R" "F" "D"]       // Rise, Fall, Dwell
BETA=[90 90 180]*%pi/180   // 90°, 90°, 180° (hasta completar 360°)

N=max(size(PdM))

i=1
sumB=0
for m=1:N
    if PdM(m)=="D" then
        TETA(i:i+1)=[sumB sumB+BETA(m)*180/%pi]
        s(i:i+1)=[0;0]  // Detenimiento en posición cero
        v(i:i+1)=[0;0]
        a(i:i+1)=[0;0]
        j(i:i+1)=[0;0]
        i=i+2
    else 
        for teta=0:BETA(m)/50:BETA(m)//Ciclo para calcular s,v,a y j
            if PdM(m)=="R" then  // Subida
                [s(i),v(i),a(i),j(i)]=Func345(teta,BETA(m),h,"subida")
            else                 // Bajada
                [s(i),v(i),a(i),j(i)]=Func345(teta,BETA(m),h,"bajada")
            end
            TETA(i)=sumB+(teta)*180/%pi;
            i=i+1
        end
    end
    sumB=sumB+BETA(m)*180/%pi
end

// Convertir a unidades con tiempo
v = v * omega        // mm/s
a = a * omega^2      // mm/s^2
j = j * omega^3      // mm/s^3

// Ángulos entre intervalos, inicia en 0.
ang(1,1)=BETA(1)*180/%pi
for i=2:N
   ang(1,i)=ang(1,i-1)+BETA(i)*180/%pi 
end

// Gráficas de s,v,a y j con función Polinomio 3-4-5
scf(1)
graficador(TETA,s,ang,["Gráfica de posición (Polinomio 3-4-5)" "" "s (mm)"],411)
graficador(TETA,v,ang,["Gráfica de velocidad (Polinomio 3-4-5)" "" "v (mm/s)"],412)
graficador(TETA,a,ang,["Gráfica de aceleración (Polinomio 3-4-5)" "" "a (mm/s^2)"],413)
graficador(TETA,j,ang,["Gráfica de jerk (Polinomio 3-4-5)" "" "j (mm/s^3)"],414)

// Mostrar valores máximos
printf("Función: Polinomio 3-4-5\n")
printf("a_max = %.2f mm/s^2\n", max(abs(a)))
printf("j_max = %.2f mm/s^3\n", max(abs(j)))
