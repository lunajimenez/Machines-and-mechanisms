// -----------------------------------------------------------------
// Code name:         Cam Design with Cycloidal Function for Problem 8-47
// Topic:             Design of Machinery
// sub-topic:         Cam Design Problem 8-47
// Author:            Luna K. Quintero J.
// Date:              05/05/2025
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

// Función Cicloidal
function [s,v,a,j]=FuncCicloidal(theta,Beta,h,tipo)
    if tipo == "subida" then
        s = h * (theta/Beta - (1/(2*%pi))*sin(2*%pi*theta/Beta))
        v = (h/Beta) * (1 - cos(2*%pi*theta/Beta))
        a = (2*%pi*h/Beta^2) * sin(2*%pi*theta/Beta)
        j = (4*%pi^2*h/Beta^3) * cos(2*%pi*theta/Beta)
    else // bajada
        s = h * (1 - theta/Beta + (1/(2*%pi))*sin(2*%pi*theta/Beta))
        v = -(h/Beta) * (1 - cos(2*%pi*theta/Beta))
        a = -(2*%pi*h/Beta^2) * sin(2*%pi*theta/Beta)
        j = -(4*%pi^2*h/Beta^3) * cos(2*%pi*theta/Beta)
    end
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
                [s(i),v(i),a(i),j(i)]=FuncCicloidal(teta,BETA(m),h,"subida")
            else                 // Bajada
                [s(i),v(i),a(i),j(i)]=FuncCicloidal(teta,BETA(m),h,"bajada")
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

// Gráficas de s,v,a y j con función Cicloidal
scf(1)
graficador(TETA,s,ang,["Gráfica de posición (Cicloidal)" "" "s (mm)"],411)
graficador(TETA,v,ang,["Gráfica de velocidad (Cicloidal)" "" "v (mm/s)"],412)
graficador(TETA,a,ang,["Gráfica de aceleración (Cicloidal)" "" "a (mm/s^2)"],413)
graficador(TETA,j,ang,["Gráfica de jerk (Cicloidal)" "" "j (mm/s^3)"],414)
