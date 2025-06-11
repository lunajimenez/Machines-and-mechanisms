// -----------------------------------------------------------------
// Code name:         Cam Design with Splines Functions
// Topic:             Design of Machinery
// Sub-topic:         Cam Design
// Problem:           8-47 - Move follower 0 to 65mm in 180°, dwell rest
// Author:            Luna K. Quintero J. y Luis E. Martínez U.
// Date:              20-05-2025
// -----------------------------------------------------------------

clc
clear

printf("=== DISEÑO DE LEVA CON SPLINES - PROBLEMA 8-47 ===\n")
printf("Mover seguidor de 0 a 65mm en 180°, detenimiento en resto\n")
printf("Tiempo total del ciclo: 2s\n\n")

// =================== PARÁMETROS DEL PROBLEMA 8-47 ===================

// Definición de segmentos para el problema 8-47:
// - Subida de 0 a 65mm en 180° (usando 4 segmentos para suavidad)
// - Detenimiento en 65mm por 180°

Beta = [45 45 45 45 180] * %pi/180  // Ángulos en radianes
hs = [0 21.67 43.33 65 65 65]      // Alturas en mm (interpolación suave para subida)
n_segments = length(Beta)            // Número de segmentos
poli = 6                            // Orden del polinomio (quíntico)

printf("Segmentos definidos:\n")
for i = 1:n_segments
    printf("Segmento %d: %.1f° - Altura: %.2f mm\n", i, Beta(i)*180/%pi, hs(i+1))
end
printf("\n")

// =================== CÁLCULO DE ÁNGULOS ACUMULADOS ===================

TETAS = zeros(1, n_segments+1)
TETAS(1) = 0

for i = 2:n_segments+1
    TETAS(i) = TETAS(i-1) + Beta(i-1)
end

printf("Ángulos acumulados (grados):\n")
for i = 1:length(TETAS)
    printf("TETA(%d) = %.2f°\n", i-1, TETAS(i)*180/%pi)
end
printf("\n")

// Cálculo de intervalos h
h_intervals = zeros(1, n_segments)
for j = 1:n_segments
    h_intervals(j) = TETAS(j+1) - TETAS(j)
end

// =================== FUNCIÓN PARA EVALUAR SPLINES QUÍNTICOS ===================

function y = eval_spline(theta_j, theta, coeffs)
    // Evalúa un spline quíntico y sus derivadas
    // theta_j: punto inicial del segmento
    // theta: punto donde evaluar
    // coeffs: coeficientes [a5 a4 a3 a2 a1 a0]
    
    x = theta - theta_j
    
    // Posición: s = a5*x^5 + a4*x^4 + a3*x^3 + a2*x^2 + a1*x + a0
    y(1) = coeffs(1)*x^5 + coeffs(2)*x^4 + coeffs(3)*x^3 + coeffs(4)*x^2 + coeffs(5)*x + coeffs(6)
    
    // Velocidad: ds/dθ = 5*a5*x^4 + 4*a4*x^3 + 3*a3*x^2 + 2*a2*x + a1
    y(2) = 5*coeffs(1)*x^4 + 4*coeffs(2)*x^3 + 3*coeffs(3)*x^2 + 2*coeffs(4)*x + coeffs(5)
    
    // Aceleración: d²s/dθ² = 20*a5*x^3 + 12*a4*x^2 + 6*a3*x + 2*a2
    y(3) = 20*coeffs(1)*x^3 + 12*coeffs(2)*x^2 + 6*coeffs(3)*x + 2*coeffs(4)
    
    // Jerk: d³s/dθ³ = 60*a5*x^2 + 24*a4*x + 6*a3
    y(4) = 60*coeffs(1)*x^2 + 24*coeffs(2)*x + 6*coeffs(3)
endfunction

// =================== CONSTRUCCIÓN DEL SISTEMA DE ECUACIONES ===================

printf("Construyendo sistema de ecuaciones para splines...\n")

// Tamaño de la matriz: 6 coeficientes por segmento
N_total = n_segments * poli
K = zeros(N_total, N_total)
b = zeros(N_total, 1)

eq_count = 1

// =================== CONDICIONES DE CONTINUIDAD ===================

for i = 1:n_segments
    col_start = (i-1)*poli + 1
    h_i = h_intervals(i)
    
    // Condición 1: s(θ_i) = h_i (posición al inicio del segmento)
    if i == 1 then
        K(eq_count, col_start+5) = 1  // a0 del primer segmento
        b(eq_count) = hs(1)           // altura inicial
    else
        // Continuidad de posición entre segmentos
        K(eq_count, col_start-6+1:col_start-6+6) = [h_intervals(i-1)^5, h_intervals(i-1)^4, h_intervals(i-1)^3, h_intervals(i-1)^2, h_intervals(i-1)^1, 1]
        K(eq_count, col_start+5) = -1
        b(eq_count) = hs(i) - hs(i)  // diferencia debe ser 0
    end
    eq_count = eq_count + 1
    
    // Condición 2: s(θ_{i+1}) = h_{i+1} (posición al final del segmento)
    K(eq_count, col_start:col_start+5) = [h_i^5, h_i^4, h_i^3, h_i^2, h_i^1, 1]
    b(eq_count) = hs(i+1)
    eq_count = eq_count + 1
    
    // Condiciones de continuidad en derivadas (excepto último segmento)
    if i < n_segments then
        // Continuidad de primera derivada
        K(eq_count, col_start:col_start+4) = [5*h_i^4, 4*h_i^3, 3*h_i^2, 2*h_i^1, 1]
        K(eq_count, col_start+6+4) = -1
        b(eq_count) = 0
        eq_count = eq_count + 1
        
        // Continuidad de segunda derivada
        K(eq_count, col_start:col_start+3) = [20*h_i^3, 12*h_i^2, 6*h_i^1, 2]
        K(eq_count, col_start+6+3) = -2
        b(eq_count) = 0
        eq_count = eq_count + 1
        
        // Continuidad de tercera derivada
        K(eq_count, col_start:col_start+2) = [60*h_i^2, 24*h_i^1, 6]
        K(eq_count, col_start+6+2) = -6
        b(eq_count) = 0
        eq_count = eq_count + 1
        
        // Continuidad de cuarta derivada
        K(eq_count, col_start:col_start+1) = [120*h_i^1, 24]
        K(eq_count, col_start+6+1) = -24
        b(eq_count) = 0
        eq_count = eq_count + 1
    end
end

// =================== CONDICIONES DE FRONTERA ===================

// Condiciones al inicio (θ = 0)
// v(0) = 0, a(0) = 0
K(eq_count, 5) = 1      // Primera derivada = 0
b(eq_count) = 0
eq_count = eq_count + 1

K(eq_count, 4) = 2      // Segunda derivada = 0  
b(eq_count) = 0
eq_count = eq_count + 1

// Condiciones al final (θ = 2π)
// v(final) = 0, a(final) = 0
last_col = (n_segments-1)*poli + 1
h_last = h_intervals(n_segments)

K(eq_count, last_col:last_col+4) = [5*h_last^4, 4*h_last^3, 3*h_last^2, 2*h_last^1, 1]
b(eq_count) = 0
eq_count = eq_count + 1

K(eq_count, last_col:last_col+3) = [20*h_last^3, 12*h_last^2, 6*h_last^1, 2]
b(eq_count) = 0

// =================== RESOLUCIÓN DEL SISTEMA ===================

printf("Resolviendo sistema de %d ecuaciones...\n", size(K,1))

try
    coefficients = K \ b
    printf("Sistema resuelto exitosamente.\n\n")
catch
    printf("Error al resolver el sistema. Verificando matriz...\n")
    printf("Determinante de K: %e\n", det(K))
    printf("Condición de K: %e\n", cond(K))
    return
end

// =================== EVALUACIÓN Y GRAFICACIÓN ===================

printf("Evaluando splines y generando gráficas...\n")

// Vectores para almacenar resultados
TETA_plot = []
s_plot = []
v_plot = []
a_plot = []
j_plot = []

// Evaluar cada segmento
points_per_segment = 50

for i = 1:n_segments
    theta_start = TETAS(i)
    theta_end = TETAS(i+1)
    
    theta_segment = linspace(theta_start, theta_end, points_per_segment)
    coeffs_segment = coefficients((i-1)*poli+1:i*poli)
    
    for j = 1:length(theta_segment)
        theta_current = theta_segment(j)
        results = eval_spline(theta_start, theta_current, coeffs_segment)
        
        TETA_plot = [TETA_plot theta_current*180/%pi]
        s_plot = [s_plot results(1)]
        v_plot = [v_plot results(2)]
        a_plot = [a_plot results(3)]
        j_plot = [j_plot results(4)]
    end
end

// =================== VISUALIZACIÓN DE RESULTADOS ===================

// Función auxiliar para gráficas
function plot_cam_data(x, y, title_str, ylabel_str, subplot_pos)
    subplot(subplot_pos)
    plot(x, y, 'b-', 'LineWidth', 2)
    
    // Líneas verticales para separar segmentos
    for i = 2:length(TETAS)
        angle_deg = TETAS(i) * 180/%pi
        plot([angle_deg, angle_deg], [min(y), max(y)], 'r--', 'LineWidth', 1)
    end
    
    xtitle(title_str, "Ángulo θ (grados)", ylabel_str)
    a = get("current_axes")
    a.axes_visible = "on"
    a.font_size = 3
    a.box = "on"
    a.grid = [1 1]
endfunction

// Crear figura con las cuatro gráficas
scf(1)
plot_cam_data(TETA_plot, s_plot, "Posición del seguidor", "s (mm)", 411)
plot_cam_data(TETA_plot, v_plot, "Velocidad del seguidor", "v (mm/rad)", 412) 
plot_cam_data(TETA_plot, a_plot, "Aceleración del seguidor", "a (mm/rad²)", 413)
plot_cam_data(TETA_plot, j_plot, "Jerk del seguidor", "j (mm/rad³)", 414)

// =================== ANÁLISIS DE RESULTADOS ===================

scf(2)
subplot(221)
plot(TETA_plot, s_plot, 'b-', 'LineWidth', 3)
xtitle("Perfil de Posición - Problema 8-47", "Ángulo θ (grados)", "Posición s (mm)")
a = get("current_axes")
a.font_size = 4
a.grid = [1 1]

subplot(222)
plot(TETA_plot, v_plot, 'r-', 'LineWidth', 2)
xtitle("Perfil de Velocidad", "Ángulo θ (grados)", "Velocidad v (mm/rad)")
a = get("current_axes")
a.font_size = 4
a.grid = [1 1]

subplot(223)
plot(TETA_plot, a_plot, 'g-', 'LineWidth', 2)
xtitle("Perfil de Aceleración", "Ángulo θ (grados)", "Aceleración a (mm/rad²)")
a = get("current_axes")
a.font_size = 4
a.grid = [1 1]

subplot(224)
plot(TETA_plot, j_plot, 'm-', 'LineWidth', 2)
xtitle("Perfil de Jerk", "Ángulo θ (grados)", "Jerk j (mm/rad³)")
a = get("current_axes")
a.font_size = 4
a.grid = [1 1]

// =================== RESUMEN DE RESULTADOS ===================

printf("=================== RESUMEN DE ANÁLISIS ===================\n")
printf("PROBLEMA 8-47 - DISEÑO CON SPLINES QUÍNTICOS\n")
printf("=========================================================\n")

printf("Desplazamiento máximo: %.2f mm\n", max(s_plot))
printf("Desplazamiento mínimo: %.2f mm\n", min(s_plot))
printf("Velocidad máxima: %.3f mm/rad\n", max(abs(v_plot)))
printf("Aceleración máxima: %.3f mm/rad²\n", max(abs(a_plot)))
printf("Jerk máximo: %.3f mm/rad³\n", max(abs(j_plot)))

printf("\nVERIFICACIÓN DE CONDICIONES DE FRONTERA:\n")
printf("Posición inicial: %.6f mm (debe ser 0)\n", s_plot(1))
printf("Velocidad inicial: %.6f mm/rad (debe ser 0)\n", v_plot(1))
printf("Posición a 180°: %.6f mm (debe ser 65)\n", s_plot(length(s_plot)/2))
printf("Velocidad final: %.6f mm/rad (debe ser 0)\n", v_plot($))

printf("\nCARACTERÍSTICAS DEL SPLINE:\n")
printf("Número de segmentos: %d\n", n_segments)
printf("Orden del polinomio: %d (quíntico)\n", poli-1)
printf("Continuidad: C⁴ (hasta cuarta derivada)\n")
printf("=========================================================\n")

// Verificar suavidad en las transiciones
printf("\nANÁLISIS DE TRANSICIONES:\n")
transition_angles = TETAS(2:$-1) * 180/%pi
for i = 1:length(transition_angles)
    printf("Transición en %.1f°: Verificar continuidad\n", transition_angles(i))
end

printf("\n=== DISEÑO COMPLETADO EXITOSAMENTE ===\n")
