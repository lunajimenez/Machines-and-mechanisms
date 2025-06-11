// -----------------------------------------------------------------
// Code name:         Cam Design with Modified Trapezoidal Function. 
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

// Función Trapezoidal Modificada
function [s,v,a,j]=FuncTrapMod(theta,Beta,h,tipo)
    if tipo == "subida" then
        // Zonas para trapezoidal modificada
        if theta <= Beta/8 then
            // Zona 1
            s = h * (0.389*theta/Beta - 0.031*sin(4*%pi*theta/Beta))
            v = 0.389*(h/Beta) * (1 - cos(4*%pi*theta/Beta))
            a = 4.888*(h/Beta^2) * sin(4*%pi*theta/Beta)
            j = 61.426*(h/Beta^3) * cos(4*%pi*theta/Beta)
        elseif theta <= 3*Beta/8 then
            // Zona 2 (aceleración constante)
            s = h * (2.444*(theta/Beta)^2 - 0.222*(theta/Beta) + 0.007)
            v = (h/Beta) * (4.888*(theta/Beta) - 0.222)
            a = 4.888 * (h/Beta^2)
            j = 0
        elseif theta <= 5*Beta/8 then
            // Zona 3
            s = h * (1.611*theta/Beta - 0.031*sin(4*%pi*theta/Beta - %pi) - 0.306)
            v = (h/Beta) * (1.611 - 0.389*cos(4*%pi*theta/Beta - %pi))
            a = 4.888*(h/Beta^2) * sin(4*%pi*theta/Beta - %pi)
            j = 61.426*(h/Beta^3) * cos(4*%pi*theta/Beta - %pi)
        elseif theta <= 7*Beta/8 then
            // Zona 4 (aceleración constante negativa)
            s = h * (-2.444*(theta/Beta)^2 + 4.666*(theta/Beta) - 1.223)
            v = (h/Beta) * (-4.888*(theta/Beta) + 4.666)
            a = -4.888 * (h/Beta^2)
            j = 0
        else
            // Zona 5
            s = h * (0.611 + 0.389*(theta/Beta) + 0.031*sin(4*%pi*theta/Beta - 3*%pi))
            v = 0.389*(h/Beta) * (1 + cos(4*%pi*theta/Beta - 3*%pi))
            a = -4.888*(h/Beta^2) * sin(4*%pi*theta/Beta - 3*%pi)
            j = -61.426*(h/Beta^3) * cos(4*%pi*theta/Beta - 3*%pi)
        end
    else // bajada
        // Para la bajada invertimos las ecuaciones
        if theta <= Beta/8 then
            s_temp = h * (0.389*theta/Beta - 0.031*sin(4*%pi*theta/Beta))
            v_temp = 0.389*(h/Beta) * (1 - cos(4*%pi*theta/Beta))
            a_temp = 4.888*(h/Beta^2) * sin(4*%pi*theta/Beta)
            j_temp = 61.426*(h/Beta^3) * cos(4*%pi*theta/Beta)
        elseif theta <= 3*Beta/8 then
            s_temp = h * (2.444*(theta/Beta)^2 - 0.222*(theta/Beta) + 0.007)
            v_temp = (h/Beta) * (4.888*(theta/Beta) - 0.222)
            a_temp = 4.888 * (h/Beta^2)
            j_temp = 0
        elseif theta <= 5*Beta/8 then
            s_temp = h * (1.611*theta/Beta - 0.031*sin(4*%pi*theta/Beta - %pi) - 0.306)
            v_temp = (h/Beta) * (1.611 - 0.389*cos(4*%pi*theta/Beta - %pi))
            a_temp = 4.888*(h/Beta^2) * sin(4*%pi*theta/Beta - %pi)
            j_temp = 61.426*(h/Beta^3) * cos(4*%pi*theta/Beta - %pi)
        elseif theta <= 7*Beta/8 then
            s_temp = h * (-2.444*(theta/Beta)^2 + 4.666*(theta/Beta) - 1.223)
            v_temp = (h/Beta) * (-4.888*(theta/Beta) + 4.666)
            a_temp = -4.888 * (h/Beta^2)
            j_temp = 0
        else
            s_temp = h * (0.611 + 0.389*(theta/Beta) + 0.031*sin(4*%pi*theta/Beta - 3*%pi))
            v_temp = 0.389*(h/Beta) * (1 + cos(4*%pi*theta/Beta - 3*%pi))
            a_temp = -4.888*(h/Beta^2) * sin(4*%pi*theta/Beta - 3*%pi)
            j_temp = -61.426*(h/Beta^3) * cos(4*%pi*theta/Beta - 3*%pi)
        end
        s = h - s_temp
        v = -v_temp
        a = -a_temp
        j = -j_temp
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
                [s(i),v(i),a(i),j(i)]=FuncTrapMod(teta,BETA(m),h,"subida")
            else                 // Bajada
                [s(i),v(i),a(i),j(i)]=FuncTrapMod(teta,BETA(m),h,"bajada")
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

// Gráficas de s,v,a y j con función Trapezoidal Modificada
scf(1)
graficador(TETA,s,ang,["Gráfica de posición (Trapezoidal Mod.)" "" "s (mm)"],411)
graficador(TETA,v,ang,["Gráfica de velocidad (Trapezoidal Mod.)" "" "v (mm/s)"],412)
graficador(TETA,a,ang,["Gráfica de aceleración (Trapezoidal Mod.)" "" "a (mm/s^2)"],413)
graficador(TETA,j,ang,["Gráfica de jerk (Trapezoidal Mod.)" "" "j (mm/s^3)"],414)

// Mostrar valores máximos
printf("Función: Trapezoidal Modificada\n")
printf("a_max = %.2f mm/s^2\n", max(abs(a)))
printf("j_max = %.2f mm/s^3\n", max(abs(j)))
