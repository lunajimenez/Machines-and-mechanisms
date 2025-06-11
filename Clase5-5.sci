// -----------------------------------------------------------------
// Code name:         Cam Design detenimiento simple polinomio. 
// Topic:             Design of Machinery
// sub-topic:         Ejercicio en clase
// Author:            Luna K. Quintero J.
// Date:              05/05/2025
// -----------------------------------------------------------------

clc
clear

// Función para graficar los diagramas S-V-A-J
function graficador(x, y, ang, T, P)
    subplot(P)
    
    a = get("current_axes");
    t = a.title;
    plot(x, y)
    
    a.x_label; a.y_label
    xtitle(T(1), T(2), T(3))
    
    t.font_size = 3; t.font_style = 4; 
    x_label = a.x_label; x_label.font_style = 4; x_label.font_size = 2
    y_label = a.y_label; y_label.font_style = 4; y_label.font_size = 2
    
    xx = [ang' ang']
    yy = [min(y) max(y)]
    for i = 1:max(size(ang))
        plot(xx(i,:), yy, 'r')
    end
    
    a = get("current_axes")
    a.axes_visible = "on";
    a.font_size = 3; 
    a.sub_tics = [5, 5];
    a.box = "off";
    a.x_location = "origin"
    a.x_ticks = tlist(["ticks" "locations", "labels"], ang', string(ang'))
endfunction

// Función para graficar el perfil de la leva
function graficador2(teta, R)
    scf
    subplot(121)
    polarplot(teta, R, style=5)
    xtitle('Diseño final de leva en coordenadas polares')
    a = get("current_axes"); t = a.title;
    t.font_size = 3; t.font_style = 4; 
    
    x = R .* cos(teta)
    y = R .* sin(teta)
    subplot(122)
    plot(x, y, 'r')
    xtitle('Diseño final de leva en coordenadas cartesianas')
    a = get("current_axes"); t = a.title;
    t.font_size = 3; t.font_style = 4; 
    f = get("current_figure");
    a = f.children
    isoview("on");
    e = a.children
    p1 = e.children(1) 
    e.children.thickness = 4;
    plot(max(R).*cos(teta), max(R).*sin(teta), 'b')
    plot(min(R).*cos(teta), min(R).*sin(teta), 'g')
endfunction

// Función polinómica 3-4-5
function [s, v, a, j] = Pf345(teta, Beta, h)
    s = h * (10 * (teta/Beta)^3 - 15 * (teta/Beta)^4 + 6 * (teta/Beta)^5)
    v = h * (30 * (teta/Beta)^2 - 60 * (teta/Beta)^3 + 30 * (teta/Beta)^4) / Beta
    a = h * (60 * (teta/Beta) - 180 * (teta/Beta)^2 + 120 * (teta/Beta)^3) / Beta^2
    j = h * (60 - 360 * (teta/Beta) + 360 * (teta/Beta)^2) / Beta^3
endfunction

// Función polinómica 4-5-6-7
function [s, v, a, j] = Pf4567(c0, c1, c2, c3, c4, c5, c6, c7, teta, Beta)
    s = c0 + c1*(teta/Beta) + c2*(teta/Beta)^2 + c3*(teta/Beta)^3 + c4*(teta/Beta)^4 + c5*(teta/Beta)^5 + c6*(teta/Beta)^6 + c7*(teta/Beta)^7
    v = (1/Beta)*(c1 + 2*c2*(teta/Beta) + 3*c3*(teta/Beta)^2 + 4*c4*(teta/Beta)^3 + 5*c5*(teta/Beta)^4 + 6*c6*(teta/Beta)^5 + 7*c7*(teta/Beta)^6)
    a = (1/Beta^2)*(2*c2 + 6*c3*(teta/Beta) + 12*c4*(teta/Beta)^2 + 20*c5*(teta/Beta)^3 + 30*c6*(teta/Beta)^4 + 42*c7*(teta/Beta)^5)
    j = (1/Beta^3)*(6*c3 + 24*c4*(teta/Beta) + 60*c5*(teta/Beta)^2 + 120*c6*(teta/Beta)^3 + 210*c7*(teta/Beta)^4)
endfunction

// Parámetros del problema
radio = 50         // Radio base de la leva
e = 0              // Excentricidad (0 para seguidor radial)
h = 1              // Altura máxima (1 pulgada = 25.4 mm)
omega = 15         // Velocidad angular (rad/s)

// Programa de movimiento
// rise 1 in (25.4 mm) in 45° and fall 1 in (25.4 mm) in 135° for 180°
// dwell at zero displacement for 180° (low dwell)
BETA_RISE = 45 * %pi/180    // 45 grados en radianes
BETA_FALL = 135 * %pi/180   // 135 grados en radianes
BETA_DWELL = 180 * %pi/180  // 180 grados en radianes

// Vector de ángulos para los segmentos
angulos = [BETA_RISE, BETA_RISE+BETA_FALL, 360] * 180/%pi

// =========================================================================
// Implementación con polinomio 3-4-5
// =========================================================================
disp("Calculando con polinomio 3-4-5...")

i = 1
// Track #1: Rise (de 0° a 45°)
for teta = 0:BETA_RISE/50:BETA_RISE
    [s_345(i), v_345(i), a_345(i), j_345(i)] = Pf345(teta, BETA_RISE, h)
    TETA_345(i) = teta * 180/%pi
    
    // Cálculos para perfil de leva
    L = s_345(i) + radio
    teta2 = atan((1/L) * v_345(i))
    R_345(i) = L / cos(teta2)
    teta3_345(i) = teta + teta2
    
    i = i + 1
end

// Track #2: Fall (de 45° a 180°)
for teta = 0:BETA_FALL/100:BETA_FALL
    [s_temp, v_temp, a_temp, j_temp] = Pf345(teta, BETA_FALL, h)
    // Inversión para la bajada
    s_345(i) = h - s_temp
    v_345(i) = -v_temp
    a_345(i) = -a_temp
    j_345(i) = -j_temp
    TETA_345(i) = (teta + BETA_RISE) * 180/%pi
    
    // Cálculos para perfil de leva
    L = s_345(i) + radio
    teta2 = atan((1/L) * v_345(i))
    R_345(i) = L / cos(teta2)
    teta3_345(i) = teta + BETA_RISE + teta2
    
    i = i + 1
end

// Track #3: Dwell (de 180° a 360°)
TETA_345(i:i+1) = [180 360]
s_345(i:i+1) = [0; 0]
v_345(i:i+1) = [0; 0]
a_345(i:i+1) = [0; 0]
j_345(i:i+1) = [0; 0]

// Cálculos para perfil de leva en dwell
deltak = 180
R_345(i:i+deltak-1) = ones(1:deltak) * radio
teta3_345(i:i+deltak-1) = linspace(BETA_RISE+BETA_FALL, 2*%pi, deltak)

// =========================================================================
// Implementación con polinomio 4-5-6-7
// =========================================================================
disp("Calculando con polinomio 4-5-6-7...")

// Calcular coeficientes para Rise y Fall con las condiciones de frontera
// Para Rise (0° a 45°):
// s(0) = 0, v(0) = 0, a(0) = 0, j(0) = 0
// s(45°) = h, v(45°) = 0, a(45°) = valor_calculado, j(45°) = valor_calculado

// Para polinomio 4-5-6-7, necesitamos 8 condiciones de contorno:
// Para subida (Rise):
// s(0)=0, v(0)=0, a(0)=0, j(0)=0, s(45°)=h, v(45°)=0, a(45°)=valor, j(45°)=valor

// Matriz de coeficientes para la subida
A_rise = [
    1, 0, 0, 0, 0, 0, 0, 0;
    0, 1, 0, 0, 0, 0, 0, 0;
    0, 0, 2, 0, 0, 0, 0, 0;
    0, 0, 0, 6, 0, 0, 0, 0;
    1, 1, 1, 1, 1, 1, 1, 1;
    0, 1, 2, 3, 4, 5, 6, 7;
    0, 0, 2, 6, 12, 20, 30, 42;
    0, 0, 0, 6, 24, 60, 120, 210;
];

// Vector de términos independientes para la subida
b_rise = [0; 0; 0; 0; h; 0; 0; 0];

// Resolver sistema para obtener coeficientes de subida
c_rise = A_rise \ b_rise;

// Para la bajada (Fall):
// s(45°)=h, v(45°)=0, a(45°)=valor, j(45°)=valor, s(180°)=0, v(180°)=0, a(180°)=0, j(180°)=0
A_fall = [
    1, 0, 0, 0, 0, 0, 0, 0;
    0, 1, 0, 0, 0, 0, 0, 0;
    0, 0, 2, 0, 0, 0, 0, 0;
    0, 0, 0, 6, 0, 0, 0, 0;
    1, 1, 1, 1, 1, 1, 1, 1;
    0, 1, 2, 3, 4, 5, 6, 7;
    0, 0, 2, 6, 12, 20, 30, 42;
    0, 0, 0, 6, 24, 60, 120, 210;
];

// Adaptamos la matriz para condiciones específicas de la bajada
A_fall(1:4,:) = A_fall(5:8,:); // Condiciones en θ=45°
A_fall(5:8,:) = [
    1, 1, 1, 1, 1, 1, 1, 1;
    0, 1, 2, 3, 4, 5, 6, 7;
    0, 0, 2, 6, 12, 20, 30, 42;
    0, 0, 0, 6, 24, 60, 120, 210;
];

// Vector de términos independientes para la bajada
b_fall = [h; 0; c_rise(7)*2/BETA_RISE^2; c_rise(8)*6/BETA_RISE^3; 0; 0; 0; 0];

// Resolver sistema para obtener coeficientes de bajada
c_fall = A_fall \ b_fall;

i = 1
// Track #1: Rise (de 0° a 45°) con polinomio 4-5-6-7
for teta = 0:BETA_RISE/50:BETA_RISE
    [s_4567(i), v_4567(i), a_4567(i), j_4567(i)] = Pf4567(c_rise(1), c_rise(2), c_rise(3), c_rise(4), c_rise(5), c_rise(6), c_rise(7), c_rise(8), teta, BETA_RISE)
    TETA_4567(i) = teta * 180/%pi
    
    // Cálculos para perfil de leva
    L = s_4567(i) + radio
    teta2 = atan((1/L) * v_4567(i))
    R_4567(i) = L / cos(teta2)
    teta3_4567(i) = teta + teta2
    
    i = i + 1
end

// Track #2: Fall (de 45° a 180°) con polinomio 4-5-6-7
for teta = 0:BETA_FALL/100:BETA_FALL
    [s_4567(i), v_4567(i), a_4567(i), j_4567(i)] = Pf4567(c_fall(1), c_fall(2), c_fall(3), c_fall(4), c_fall(5), c_fall(6), c_fall(7), c_fall(8), teta, BETA_FALL)
    TETA_4567(i) = (teta + BETA_RISE) * 180/%pi
    
    // Cálculos para perfil de leva
    L = s_4567(i) + radio
    teta2 = atan((1/L) * v_4567(i))
    R_4567(i) = L / cos(teta2)
    teta3_4567(i) = teta + BETA_RISE + teta2
    
    i = i + 1
end

// Track #3: Dwell (de 180° a 360°)
TETA_4567(i:i+1) = [180 360]
s_4567(i:i+1) = [0; 0]
v_4567(i:i+1) = [0; 0]
a_4567(i:i+1) = [0; 0]
j_4567(i:i+1) = [0; 0]

// Cálculos para perfil de leva en dwell
deltak = 180
R_4567(i:i+deltak-1) = ones(1:deltak) * radio
teta3_4567(i:i+deltak-1) = linspace(BETA_RISE+BETA_FALL, 2*%pi, deltak)

// =========================================================================
// Gráficas comparativas de los dos polinomios
// =========================================================================

// Gráficas para polinomio 3-4-5
scf(1)
graficador(TETA_345, s_345, angulos, ["Polinomio 3-4-5: Posición" "" "s (in)"], 411)
graficador(TETA_345, v_345, angulos, ["Polinomio 3-4-5: Velocidad" "" "v (in/rad)"], 412)
graficador(TETA_345, a_345, angulos, ["Polinomio 3-4-5: Aceleración" "$\theta(Grados)$" "a (in/rad^2)"], 413)
graficador(TETA_345, j_345, angulos, ["Polinomio 3-4-5: Jerk" "" "j (in/rad^3)"], 414)

// Gráficas para polinomio 4-5-6-7
scf(2)
graficador(TETA_4567, s_4567, angulos, ["Polinomio 4-5-6-7: Posición" "" "s (in)"], 411)
graficador(TETA_4567, v_4567, angulos, ["Polinomio 4-5-6-7: Velocidad" "" "v (in/rad)"], 412)
graficador(TETA_4567, a_4567, angulos, ["Polinomio 4-5-6-7: Aceleración" "$\theta(Grados)$" "a (in/rad^2)"], 413)
graficador(TETA_4567, j_4567, angulos, ["Polinomio 4-5-6-7: Jerk" "" "j (in/rad^3)"], 414)

// Perfil de la leva para ambos polinomios
scf(3)
subplot(121)
graficador2(teta3_345, R_345)
title("Perfil de leva con polinomio 3-4-5")

scf(4)
subplot(121)
graficador2(teta3_4567, R_4567)
title("Perfil de leva con polinomio 4-5-6-7")

// Información del diseño
disp("Información del diseño de leva:")
disp("----------------------------------------")
disp("Rise: 1 pulgada en 45°")
disp("Fall: 1 pulgada en 135°")
disp("Dwell: En posición cero durante 180°")
disp("Velocidad angular de la leva: 15 rad/s (143.24 rpm)")
disp("----------------------------------------")

// Valores máximos y mínimos importantes
disp("Polinomio 3-4-5:")
disp("Max Velocidad: " + string(max(abs(v_345))) + " in/rad")
disp("Max Aceleración: " + string(max(abs(a_345))) + " in/rad^2")
disp("Max Jerk: " + string(max(abs(j_345))) + " in/rad^3")

disp("Polinomio 4-5-6-7:")
disp("Max Velocidad: " + string(max(abs(v_4567))) + " in/rad")
disp("Max Aceleración: " + string(max(abs(a_4567))) + " in/rad^2")
disp("Max Jerk: " + string(max(abs(j_4567))) + " in/rad^3")
