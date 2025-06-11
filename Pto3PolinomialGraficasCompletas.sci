// -----------------------------------------------------------------
// Code name:         Punto 3 Graficas Completas Diferentes Funciones
// Topic:             Design of Machinery
// Sub-topic:         Cam Design
// Problem:           8-47 - Move follower 0 to 65mm in 180°, dwell rest
// Author:            Luna K. Quintero J. y Luis E. Martínez U.
// Date:              20-05-2025
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

// Añadimos una función para crear gráficos polares manualmente (sin usar polarplot)
function manual_polarplot(theta, rho)
    x = rho.*cos(theta)
    y = rho.*sin(theta)
    plot(x, y, 'r-', 'linewidth', 2)
    // Dibujamos los ejes
    t = linspace(0, 2*%pi, 100)
    xmin = min(rho)
    xmax = max(rho)
    // Ejes circulares de referencia
    for r = linspace(xmin, xmax, 4)
        x_circle = r*cos(t)
        y_circle = r*sin(t)
        plot(x_circle, y_circle, 'k--', 'linewidth', 0.5)
    end
    // Ejes radiales
    for ang = linspace(0, 2*%pi-(%pi/4), 8)
        plot([0, xmax*cos(ang)], [0, xmax*sin(ang)], 'k--', 'linewidth', 0.5)
    end
    isoview("on")
endfunction

function graficador2(teta,R)
    scf
    subplot(121)
    // Reemplazamos polarplot con nuestra función manual
    manual_polarplot(teta, R)
    xtitle('Diseño final de leva en coordenadas polares')
    a=get("current_axes") ;   t=a.title;
    type(a.title)
    t.font_size=3;  t.font_style=4; 
    
    x=R.*cos(teta)
    y=R.*sin(teta)
    subplot(122)
    plot(x,y,'r')
    xtitle('Diseño final de leva en coordenadas cartesianas')
    a=get("current_axes") ;   t=a.title;
        type(a.title)
    t.font_size=3;  t.font_style=4; 
    f=get("current_figure"); // Handle on axes entity
    a=f.children
    isoview("on");
    e=a.children // list the children of the axes : here it is an Compound child composed of 2 entities
    p1=e.children(1) 
    e.children.thickness=4; // change the thickness of the two polylines
    plot(max(R).*cos(teta),max(R).*sin(teta),'b')
    plot(min(R).*cos(teta),min(R).*sin(teta),'g')
endfunction

//Funcion polinomica 4-5-6-7
function [s,v,a,j]=Pf(c0,c1,c2,c3,c4,c5,c6,c7,teta,Beta,h)
    s = h*(35*((teta/Beta)^4)-84*((teta/Beta)^5)+70*((teta/Beta)^6)-20*((teta/Beta)^7))
    
    v = (h/Beta)*(140*((teta/Beta)^3)-420*((teta/Beta)^4)+420*((teta/Beta)^5)-140*((teta/Beta)^6))
    
    a = (h/Beta^2)*(420*((teta/Beta)^2)-1680*((teta/Beta)^3)+2100*((teta/Beta)^4)-840*((teta/Beta)^5))
    
    j = (h/Beta^3)*(840*(teta/Beta)-5040*((teta/Beta)^2)+8400*((teta/Beta)^3)-4200*((teta/Beta)^4))

endfunction

radio=180                 //Definicion del radio Base (aumentado para reducir ángulos de presión)

e=15                    //Definicion de excentricidad (agregada para balancear ángulos)

//Datos de entrada
PdM=["R" "F" "D"]       //Programa de mov.
BETA=[90 90 180]
BETA(4)=360-sum(BETA)
BETA=BETA*%pi/180//BETA=[60 120 30 150]*%pi/180    //Intevalos de mov
h=60                     //Desplazamiento máximo (requerido)

c=[0  0 0 0  35*h -84*h  70*h  -20*h
   0  0 0 0   0       0        0       0   
   h  0 0 0 -35*h  84*h  -70*h  20*h
   0  0 0 0   0       0        0       0]
N=max(size(PdM))



i=1
k=1
deltak=120
sumB=0
for m=1:N
    if PdM(m)=="D" then
        TETA(i:i+1)=[sumB sumB+BETA(m)*180/%pi]
        if i==1 then
            s(i:i+1)=[0;0]
        else
            s(i:i+1)=[s(i-1);s(i-1)]
        end
        v(i:i+1)=[0;0]
        a(i:i+1)=[0;0]
        j(i:i+1)=[0;0]

        //*************Calculos de forma de leva*************************
        temp = linspace(sumB, sumB+BETA(m)*180/%pi, deltak)
        R(k:k+deltak-1)=ones(1, deltak)*(radio)
        teta3(k:k+deltak-1)=temp*%pi/180
        //******************************************************************
        i=i+2
        k=k+deltak
    else 
        for teta=0:BETA(m)/50:BETA(m)//Ciclo para calcular s,v,a y j en intervalo 
                     if PdM(m)=="R" then
           [Sini,Vini,Aini,Jini]=Pf(c(m,1),c(m,2),c(m,3),c(m,4),c(m,5),c(m,6),c(m,7),c(m,8),teta,BETA(m),h)
            
         elseif PdM(m) == "F" then
         [Sfinal,Vfinal,Afinal,Jfinal]=Pf(c(m,1),c(m,2),c(m,3),c(m,4),c(m,5),c(m,6),c(m,7),c(m,8),teta,BETA(m),h)
             Sini= h-Sfinal
             Vini=-Vfinal
             Aini=-Afinal
             Jini=-Jfinal
             end
s(i)= Sini
v(i)= Vini
a(i)= Aini
j(i)= Jini
TETA(i)=sumB+(teta)*180/%pi ;

            //*******************Calculos de forma de leva*****************
            L=s(i)+radio
            teta2=atan((1/L)*v(i))
            R(k)=sqrt((radio+s(i))^2+(v(i))^2)//L/cos(teta2)
            teta3(k)=sumB*%pi/180+teta+teta2

            alpha=atan(L*v(i)/(e*e+L*L-e*v(i)))
            //  Rx(i)=sqrt(L*L+e*e)-10*cos(alpha)
            //  Ry(i)=10*sin(alpha)
            //**************************************************************  
            i=i+1
            k=k+1
        end
    end 
    sumB=sumB+BETA(m)*180/%pi
end

// Angulos entre intercalor, inicia en 0.
ang = zeros(1, N)
ang(1,1)=BETA(1)*180/%pi
for i=2:N
   ang(1,i)=ang(1,i-1)+BETA(i)*180/%pi 
end

//_____________________________________________________________________________
//                                Graficas de s,v,a y j
scf
graficador(TETA,s,ang,["Gráfica de posición" "" "s (in)"],411)
graficador(TETA,v,ang,["Gráfica de velocidad" "" "v (in/rad)"],412)
graficador(TETA,a,ang,["Gráfica de Aceleración" "$\textbf{\textstyle\theta(Grad)}$" "a (in/rad^2)"],413)
graficador(TETA,j,ang,["Gráfica de Golpeteo" "" "j (in/rad^3)"],414)
//_____________________________________________________________________________

// CÁLCULO Y VISUALIZACIÓN DEL RADIO DE CURVATURA
// El radio de curvatura determina si hay problemas de mecanizado o desgaste excesivo
rho=(((radio+s).^2+v.^2).^(3/2))./((radio+s).^2+2*v.^2-a.*(radio+s))

// Gráfica del radio de curvatura
scf
subplot(211)
plot(TETA, rho, 'b-', 'LineWidth', 2)
a=get("current_axes")
a.axes_visible="on"
a.font_size=3
a.box="on"
xtitle("Radio de curvatura vs Ángulo de la leva", "Ángulo θ (grados)", "Radio de curvatura ρ (mm)")
t=a.title
t.font_size=4
t.font_style=4
x_label=a.x_label
x_label.font_style=4
x_label.font_size=3
y_label=a.y_label
y_label.font_style=4
y_label.font_size=3

// Valor mínimo del radio de curvatura
rho_min = min(rho)
subplot(212)
plot(TETA, ones(TETA)*rho_min, 'r--', 'LineWidth', 1.5)
plot(TETA, rho, 'b-', 'LineWidth', 2)
a=get("current_axes")
a.axes_visible="on"
a.font_size=3
a.box="on"
legend(['Valor mínimo: ' + string(rho_min) + ' mm'; 'Radio de curvatura'])
xtitle("Radio de curvatura - Valor mínimo", "Ángulo θ (grados)", "Radio de curvatura ρ (mm)")
t=a.title
t.font_size=4
t.font_style=4
x_label=a.x_label
x_label.font_style=4
x_label.font_size=3
y_label=a.y_label
y_label.font_style=4
y_label.font_size=3

// CÁLCULO Y VISUALIZACIÓN DEL ÁNGULO DE PRESIÓN
// El ángulo de presión afecta la transmisión de fuerzas y debe mantenerse en límites adecuados
phi = atan((v-e)./(s+sqrt(radio^2-e^2))) * 180/%pi  // Convertido a grados

// Gráfica del ángulo de presión
scf
plot(TETA, phi, 'b-', 'LineWidth', 2)
plot(TETA, ones(TETA)*30, 'r--', 'LineWidth', 1.5)
plot(TETA, ones(TETA)*(-30), 'r--', 'LineWidth', 1.5)
a=get("current_axes")
a.axes_visible="on"
a.font_size=3
a.box="on"
legend(['Ángulo de presión'; 'Límite superior (30°)'; 'Límite inferior (-30°)'])
xtitle("Ángulo de presión vs Ángulo de la leva", "Ángulo θ (grados)", "Ángulo de presión φ (grados)")
t=a.title
t.font_size=4
t.font_style=4
x_label=a.x_label
x_label.font_style=4
x_label.font_size=3
y_label=a.y_label
y_label.font_style=4
y_label.font_size=3

// Análisis del ángulo de presión - corregido para evitar problemas con abs()
phi_real = phi(isreal(phi))  // Filtrar solo valores reales
phi_abs = abs(phi_real)      // Calcular valor absoluto
phi_max = max(phi_abs)       // Obtener el máximo

disp("Ángulo de presión máximo (absoluto): " + string(phi_max) + " grados")
if phi_max > 30 then
    disp("ADVERTENCIA: El ángulo de presión máximo excede los 30 grados recomendados")
    disp("Considere modificar los parámetros de diseño para reducir el ángulo de presión")
else
    disp("El ángulo de presión está dentro de los límites recomendados (<30°)")
end

// VISUALIZACIÓN DE LA FORMA DE LA LEVA
// Cálculo de las coordenadas para el seguidor de rodillo
d = sqrt(radio^2-e^2)
scf
subplot(221)
// Reemplazamos polarplot con nuestra función manual
manual_polarplot(teta3, R)
xtitle('Forma de la leva en coordenadas polares')
a=get("current_axes")
t=a.title
t.font_size=4
t.font_style=4

// Graficando la forma de la leva en coordenadas cartesianas
x = R.*cos(teta3)
y = R.*sin(teta3)
subplot(222)
plot(x, y, 'r-', 'linewidth', 2)
xtitle('Forma de la leva en coordenadas cartesianas')
a=get("current_axes")
t=a.title
t.font_size=4
t.font_style=4
isoview("on")

// Para seguidor de cara plana
Vector_r = (radio+s).*sin(TETA*%pi/180)+v.*cos(TETA*%pi/180)
Vector_q = (radio+s).*cos(TETA*%pi/180)-v.*sin(TETA*%pi/180)

subplot(223)
plot(Vector_q, Vector_r, 'b-', 'linewidth', 2)
xtitle('Forma de la leva (seguidor de cara plana)')
a=get("current_axes")
t=a.title
t.font_size=4
t.font_style=4
isoview("on")

// Perfil de leva con círculo base
subplot(224)
plot(x, y, 'r-', 'linewidth', 2)
t = linspace(0, 2*%pi, 100)
x_circle = radio*cos(t)
y_circle = radio*sin(t)
plot(x_circle, y_circle, 'g--', 'linewidth', 1.5)
xtitle('Perfil de leva con círculo base')
legend(['Perfil de leva'; 'Círculo base'])
a=get("current_axes")
t=a.title
t.font_size=4
t.font_style=4
isoview("on")

// CREAR FIGURA ADICIONAL DEDICADA A LA FORMA DE LA LEVA
scf
subplot(121)
// Vista completa de la leva en coordenadas cartesianas
plot(x, y, 'r-', 'linewidth', 3)
plot(x_circle, y_circle, 'b--', 'linewidth', 1.5)
xtitle('Forma final de la leva', 'X (mm)', 'Y (mm)')
a=get("current_axes")
t=a.title
t.font_size=4
t.font_style=4
x_label=a.x_label
x_label.font_style=4
x_label.font_size=3
y_label=a.y_label
y_label.font_style=4
y_label.font_size=3
legend(['Perfil de leva'; 'Círculo base'])
isoview("on")

// Agregamos vista polar manual en lugar de polarplot
subplot(122)
manual_polarplot(teta3, R)
xtitle('Forma de la leva (vista polar)', 'X (mm)', 'Y (mm)')
a=get("current_axes")
t=a.title
t.font_size=4
t.font_style=4
x_label=a.x_label
x_label.font_style=4
x_label.font_size=3
y_label=a.y_label
y_label.font_style=4
y_label.font_size=3
legend(['Perfil de leva'])
isoview("on")

// RESUMEN DE PARÁMETROS IMPORTANTES
printf("\n=================== RESUMEN DE DISEÑO DE LEVA ===================\n")
printf("Radio base: %.2f mm\n", radio)
printf("Excentricidad: %.2f mm\n", e)
printf("Desplazamiento máximo del seguidor: %.2f mm\n", max(s))

// Corregir uso de abs() con números escalares
v_max = max(abs(v(isreal(v))))
a_max = max(abs(a(isreal(a))))
printf("Velocidad máxima del seguidor: %.2f mm/rad\n", v_max)
printf("Aceleración máxima del seguidor: %.2f mm/rad²\n", a_max)
printf("Radio de curvatura mínimo: %.2f mm\n", min(rho))
printf("Ángulo de presión máximo: %.2f grados\n", phi_max)
printf("================================================================\n")
