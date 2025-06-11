// -----------------------------------------------------------------
// Code name:         Cam Desing exercise 8-46. 
// Topic:             Desing of Machinery
// sub-topic:         Cam Desing
// Author:            Luna K. Quintero J. y Luis E. Martinez U.
// Copyright (C) 2025 
// Date of creation:   03-05-2025
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

    // Haxes=gca()
    a.x_ticks = tlist(["ticks" "locations", "labels"], ang', string(ang'))
endfunction

//Función Polinomial 4-5-6-7
function [s,v,a,j]=FuncPol4567(theta,Beta,h,tipo)
    if tipo == "subida" then
        // Para subida: s = h * [35(θ/β)^4 - 84(θ/β)^5 + 70(θ/β)^6 - 20(θ/β)^7]
        c0 = 0; c1 = 0; c2 = 0; c3 = 0;
        c4 = 35*h; c5 = -84*h; c6 = 70*h; c7 = -20*h;
    else // bajada
        // Para bajada: usar los mismos coeficientes pero con s = h(1-...) 
        c0 = h; c1 = 0; c2 = 0; c3 = 0;
        c4 = -35*h; c5 = 84*h; c6 = -70*h; c7 = 20*h;
    end
    
    s = c0 + c1*(theta/Beta) + c2*(theta/Beta)^2 + c3*(theta/Beta)^3 + c4*(theta/Beta)^4 + c5*(theta/Beta)^5 + c6*(theta/Beta)^6 + c7*(theta/Beta)^7;
    v = (1/Beta)*(c1 + 2*c2*(theta/Beta) + 3*c3*(theta/Beta)^2 + 4*c4*(theta/Beta)^3 + 5*c5*(theta/Beta)^4 + 6*c6*(theta/Beta)^5 + 7*c7*(theta/Beta)^6);
    a = (1/Beta^2)*(2*c2 + 6*c3*(theta/Beta) + 12*c4*(theta/Beta)^2 + 20*c5*(theta/Beta)^3 + 30*c6*(theta/Beta)^4 + 42*c7*(theta/Beta)^5);
    j = (1/Beta^3)*(6*c3 + 24*c4*(theta/Beta) + 60*c5*(theta/Beta)^2 + 120*c6*(theta/Beta)^3 + 210*c7*(theta/Beta)^4);
endfunction

//_____________________________________________________________________________
//Datos de entrada para el Problema 8-46
h = 50        // Desplazamiento total en mm
t_ciclo = 5   // Tiempo del ciclo en segundos
omega = 2*%pi/t_ciclo    // Velocidad angular rad/s

//Datos de entrada
PdM=["R" "D" "F" "D"]       //Programa de mov.
BETA=[75 75 75 135]*%pi/180    //Intervalos de mov en radianes

N=max(size(PdM))

i=1
sumB=0
for m=1:N
    if PdM(m)=="D" then
        TETA(i:i+1)=[sumB sumB+BETA(m)*180/%pi]
        if m == 2 then  // Primer dwell (arriba)
            s(i:i+1)=[h;h]
        else           // Segundo dwell (abajo)
            s(i:i+1)=[0;0]
        end
        v(i:i+1)=[0;0]
        a(i:i+1)=[0;0]
        j(i:i+1)=[0;0]
        i=i+2
    else 
        for teta=0:BETA(m)/50:BETA(m)//Ciclo para calcular s,v,a y j en el intervalo  
            if PdM(m)=="R" then  // Subida
                [s(i),v(i),a(i),j(i)]=FuncPol4567(teta,BETA(m),h,"subida")
            else                 // Bajada
                [s(i),v(i),a(i),j(i)]=FuncPol4567(teta,BETA(m),h,"bajada")
            end
            TETA(i)=sumB+(teta)*180/%pi ;
            i=i+1
        end
    end
    sumB=sumB+BETA(m)*180/%pi
end

// Convertir a unidades con tiempo
v = v * omega        // mm/s
a = a * omega^2      // mm/s^2
j = j * omega^3      // mm/s^3

//Angulos entre intervalos, inicia en 0.
ang(1,1)=BETA(1)*180/%pi
for i=2:N
   ang(1,i)=ang(1,i-1)+BETA(i)*180/%pi 
end

//_____________________________________________________________________________
//                                Graficas de s,v,a y j
graficador(TETA,s,ang,["Gráfica de posición" "" "s (mm)"],411)
graficador(TETA,v,ang,["Gráfica de velocidad" "" "v (mm/s)"],412)
graficador(TETA,a,ang,["Gráfica de aceleración" "" "a (mm/s^2)"],413)
graficador(TETA,j,ang,["Gráfica de jerk" "" "j (mm/s^3)"],414)

// Mostrar valores máximos
printf("Valores máximos:\n")
printf("s_max = %.2f mm\n", max(abs(s)))
printf("v_max = %.2f mm/s\n", max(abs(v)))
printf("a_max = %.2f mm/s^2\n", max(abs(a)))
printf("j_max = %.2f mm/s^3\n", max(abs(j)))
