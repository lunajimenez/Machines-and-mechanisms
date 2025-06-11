// -----------------------------------------------------------------
// Code name:         Cam Design with Critical Path Motion (CPM)
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

// Función para CPM con velocidad constante y polinomios en las transiciones
function [s,v,a,j]=FuncCPM(theta,Beta,h,v_const,tipo,parte)
    // tipo: "aceleracion", "vel_constante", "desaceleracion"
    // parte: "avance" o "retorno"
    
    // Velocidad constante: v = constante, a = 0, j = 0
    if tipo == "vel_constante" then
        if parte == "avance" then
            s = v_const * (theta/Beta) * (Beta/%pi)  // Convertimos theta a tiempo
            v = v_const
            a = 0
            j = 0
        else  // retorno
            s = h - v_const * (theta/Beta) * (Beta/%pi)
            v = -v_const
            a = 0
            j = 0
        end
    
    // Aceleración con polinomio grado 5 para transición suave
    elseif tipo == "aceleracion" then
        if parte == "avance" then
            // Polinomio de grado 5 para aceleración de 0 a v_const
            c0 = 0; c1 = 0; c2 = 0; 
            c3 = 10*v_const*(Beta/%pi); c4 = -15*v_const*(Beta/%pi); c5 = 6*v_const*(Beta/%pi);
            
            s = c0 + c1*(theta/Beta) + c2*(theta/Beta)^2 + c3*(theta/Beta)^3 + c4*(theta/Beta)^4 + c5*(theta/Beta)^5
            v = (1/Beta)*(c1 + 2*c2*(theta/Beta) + 3*c3*(theta/Beta)^2 + 4*c4*(theta/Beta)^3 + 5*c5*(theta/Beta)^4)
            a = (1/Beta^2)*(2*c2 + 6*c3*(theta/Beta) + 12*c4*(theta/Beta)^2 + 20*c5*(theta/Beta)^3)
            j = (1/Beta^3)*(6*c3 + 24*c4*(theta/Beta) + 60*c5*(theta/Beta)^2)
        else  // retorno
            // Para el retorno la aceleración es en sentido contrario
            c0 = h; c1 = 0; c2 = 0; 
            c3 = -10*v_const*(Beta/%pi); c4 = 15*v_const*(Beta/%pi); c5 = -6*v_const*(Beta/%pi);
            
            s = c0 + c1*(theta/Beta) + c2*(theta/Beta)^2 + c3*(theta/Beta)^3 + c4*(theta/Beta)^4 + c5*(theta/Beta)^5
            v = (1/Beta)*(c1 + 2*c2*(theta/Beta) + 3*c3*(theta/Beta)^2 + 4*c4*(theta/Beta)^3 + 5*c5*(theta/Beta)^4)
            a = (1/Beta^2)*(2*c2 + 6*c3*(theta/Beta) + 12*c4*(theta/Beta)^2 + 20*c5*(theta/Beta)^3)
            j = (1/Beta^3)*(6*c3 + 24*c4*(theta/Beta) + 60*c5*(theta/Beta)^2)
        end
    
    // Desaceleración con polinomio grado 5 para transición suave
    else  // desaceleracion
        if parte == "avance" then
            // Polinomio de grado 5 para desaceleración de v_const a 0
            // La posición inicial es la que tendría después de la velocidad constante
            s_inicio = v_const * (Beta/%pi)  // Distancia recorrida a velocidad constante
            
            c0 = s_inicio; c1 = v_const*(Beta/%pi); c2 = 0; 
            c3 = -10*v_const*(Beta/%pi); c4 = 15*v_const*(Beta/%pi); c5 = -6*v_const*(Beta/%pi);
            
            s = c0 + c1*(theta/Beta) + c2*(theta/Beta)^2 + c3*(theta/Beta)^3 + c4*(theta/Beta)^4 + c5*(theta/Beta)^5
            v = (1/Beta)*(c1 + 2*c2*(theta/Beta) + 3*c3*(theta/Beta)^2 + 4*c4*(theta/Beta)^3 + 5*c5*(theta/Beta)^4)
            a = (1/Beta^2)*(2*c2 + 6*c3*(theta/Beta) + 12*c4*(theta/Beta)^2 + 20*c5*(theta/Beta)^3)
            j = (1/Beta^3)*(6*c3 + 24*c4*(theta/Beta) + 60*c5*(theta/Beta)^2)
        else  // retorno
            // Para el retorno la desaceleración es en sentido contrario
            s_inicio = 0  // Hacia la posición 0
            
            c0 = s_inicio; c1 = -v_const*(Beta/%pi); c2 = 0; 
            c3 = 10*v_const*(Beta/%pi); c4 = -15*v_const*(Beta/%pi); c5 = 6*v_const*(Beta/%pi);
            
            s = c0 + c1*(theta/Beta) + c2*(theta/Beta)^2 + c3*(theta/Beta)^3 + c4*(theta/Beta)^4 + c5*(theta/Beta)^5
            v = (1/Beta)*(c1 + 2*c2*(theta/Beta) + 3*c3*(theta/Beta)^2 + 4*c4*(theta/Beta)^3 + 5*c5*(theta/Beta)^4)
            a = (1/Beta^2)*(2*c2 + 6*c3*(theta/Beta) + 12*c4*(theta/Beta)^2 + 20*c5*(theta/Beta)^3)
            j = (1/Beta^3)*(6*c3 + 24*c4*(theta/Beta) + 60*c5*(theta/Beta)^2)
        end
    end
endfunction

//_____________________________________________________________________________
// Datos de entrada para el Problema 8-48
v_const = 200       // Velocidad constante en mm/s
t_ciclo = 6         // Tiempo total del ciclo en segundos
omega = 2*%pi/t_ciclo    // Velocidad angular rad/s
t_vel_const = 3     // Tiempo a velocidad constante en segundos

// Calcular el desplazamiento máximo
h = v_const * t_vel_const  // Desplazamiento = velocidad * tiempo = 600 mm

// Dividir el movimiento en segmentos
// Fase 1: Aceleración en avance
// Fase 2: Velocidad constante en avance
// Fase 3: Desaceleración en avance
// Fase 4: Aceleración en retorno
// Fase 5: Velocidad constante en retorno
// Fase 6: Desaceleración en retorno

// Asumimos que cada fase de aceleración/desaceleración toma 15% del tiempo total
t_acel = 0.15 * t_ciclo / 2  // 15% de medio ciclo
t_vel_const_red = t_vel_const - 2*t_acel  // Tiempo a vel constante reducido por aceleraciones

// Calcular ángulos en radianes para cada fase
// Primer semicírculo (avance)
Beta_acel_av = (t_acel/t_ciclo) * 2*%pi  // Aceleración avance
Beta_vel_av = (t_vel_const_red/t_ciclo) * 2*%pi  // Velocidad constante avance
Beta_desacel_av = (t_acel/t_ciclo) * 2*%pi  // Desaceleración avance

// Segundo semicírculo (retorno)
Beta_acel_ret = (t_acel/t_ciclo) * 2*%pi  // Aceleración retorno
Beta_vel_ret = (t_vel_const_red/t_ciclo) * 2*%pi  // Velocidad constante retorno
Beta_desacel_ret = (t_acel/t_ciclo) * 2*%pi  // Desaceleración retorno

// Programa de movimiento
PdM=["ACEL_AV" "VEL_AV" "DESACEL_AV" "ACEL_RET" "VEL_RET" "DESACEL_RET"]
BETA=[Beta_acel_av Beta_vel_av Beta_desacel_av Beta_acel_ret Beta_vel_ret Beta_desacel_ret]

N=max(size(PdM))

i=1
sumB=0
for m=1:N
    // Calcular ángulo inicial y final para este segmento en grados
    ang_ini = sumB
    ang_fin = sumB + BETA(m)*180/%pi
    
    // Calcular el movimiento para este segmento
    for teta=0:BETA(m)/50:BETA(m)
        select PdM(m)
        case "ACEL_AV" then
            [s(i),v(i),a(i),j(i)] = FuncCPM(teta,BETA(m),h,v_const,"aceleracion","avance")
        case "VEL_AV" then
            [s(i),v(i),a(i),j(i)] = FuncCPM(teta,BETA(m),h,v_const,"vel_constante","avance")
        case "DESACEL_AV" then
            [s(i),v(i),a(i),j(i)] = FuncCPM(teta,BETA(m),h,v_const,"desaceleracion","avance")
        case "ACEL_RET" then
            [s(i),v(i),a(i),j(i)] = FuncCPM(teta,BETA(m),h,v_const,"aceleracion","retorno")
        case "VEL_RET" then
            [s(i),v(i),a(i),j(i)] = FuncCPM(teta,BETA(m),h,v_const,"vel_constante","retorno")
        case "DESACEL_RET" then
            [s(i),v(i),a(i),j(i)] = FuncCPM(teta,BETA(m),h,v_const,"desaceleracion","retorno")
        end
        TETA(i) = sumB + (teta*180/%pi)
        i = i + 1
    end
    sumB = sumB + BETA(m)*180/%pi
end

// La velocidad ya está en mm/s, convertimos a y j
a = a * omega      // Convertimos a mm/s²
j = j * omega^2    // Convertimos a mm/s³

// Ángulos entre intervalos, inicia en 0.
ang(1,:) = [Beta_acel_av, Beta_vel_av, Beta_desacel_av, Beta_acel_ret, Beta_vel_ret, Beta_desacel_ret]
ang(1,:) = ang(1,:) * 180/%pi
for i=2:N
   ang(1,i) = ang(1,i-1) + ang(1,i)
end

// Gráficas de s,v,a y j para el movimiento CPM
scf(1)
graficador(TETA,s,ang,["Gráfica de posición (CPM)" "" "s (mm)"],411)
graficador(TETA,v,ang,["Gráfica de velocidad (CPM)" "" "v (mm/s)"],412)
graficador(TETA,a,ang,["Gráfica de aceleración (CPM)" "" "a (mm/s^2)"],413)
graficador(TETA,j,ang,["Gráfica de jerk (CPM)" "" "j (mm/s^3)"],414)

// Mostrar valores máximos
printf("Función: Critical Path Motion (CPM)\n")
printf("Desplazamiento máximo = %.2f mm\n", max(abs(s)))
printf("Velocidad constante = %.2f mm/s\n", v_const)
printf("a_max = %.2f mm/s^2\n", max(abs(a)))
printf("j_max = %.2f mm/s^3\n", max(abs(j)))
