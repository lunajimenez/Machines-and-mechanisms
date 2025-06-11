// -----------------------------------------------------------------
// Code name:         Point 3 Testing. 
// Topic:             Desing of Machinery
// sub-topic:         Cam Desing
// Author:            Luna K. Quintero J. y Luis E. Martinez U.
// Copyright (C) 2025 
// Date of creation:   15-05-2025
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

function graficador2(teta,R)
    scf
    subplot(121)
    polarplot(teta,R,style=5)
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

radio=45                 //Definicion del radio Base

e=0                    //Definicion de excentricidad

//Datos de entrada
PdM=["R" "F" "D"]       //Programa de mov.
BETA=[90 90 180]
BETA(4)=360-sum(BETA)
BETA=BETA*%pi/180//BETA=[60 120 30 150]*%pi/180    //Intevalos de mov
h=60

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

/*
//_____________________________________________________________________________
//                      Grafica de la forma de la leva
//graficador2(teta3,R)
rho=(((radio+s)^2+v^2)^(3/2))./((radio+s)^2+2*v^2-a.*(radio+s))
scf
plot(TETA,rho)
pause
scf
TETA($)=[]
s($)=[]
v($)=[]

TETAc=linspace(TETA($),360,50)
TETA=[TETA;TETAc']
s=[s;ones(TETAc)'*0]
v=[v;ones(TETAc)'*0]
r=(radio+s).*sind(TETA)+v.*cosd(TETA)
q=(radio+s).*cosd(TETA)-v.*sind(TETA)
scf
plot(r,q)
isoview
phi=atand((v-e)./(s+sqrt(radio*radio-e*e)))
scf
plot(TETA,phi)

//_____________________________________________________________________________
x=[]
y=[]
d=sqrt(radio^2-e^2)
lamda=(TETA*%pi/180)+atan(e./(d+s))//(2*%pi-TETA*%pi/180)-atan(e./(d+s))
x=cos(lamda).*sqrt((d+s)+e*e)
y=sin(lamda).*sqrt((d+s)+e*e)

scf
plot(x,y)
isoview
    polarplot(lamda,sqrt((d+s)+e*e),style=5)

*/
scf
r = s+radio
//plot(r.*cosd(TETA),r.*sind(TETA))
TETA  = TETA*%pi/180
//Calculos para seguidor tipo rodillo
d     = (radio^2-e^2)^(1/2)
lamda = (2*%pi-TETA)-atan(e/(d+s))'

x = cos(lamda).*((d+s).^2+(e).^2).^(1/2)
y = sin(lamda).*((d+s).^2+(e).^2).^(1/2)
phi = atan((v-e)./(s+(radio^2-e^2).^(1/2)))
rho = (((radio+s).^2+v.^2).^(3/2))./((radio+s).^2+2*v.^2-a.*(radio+s))



//CAlculos para seguirod de tipo cara plana
Vector_r = (radio+s).*sin(TETA)+v.*cos(TETA)
Vector_q = (radio+s).*cos(TETA)-v.*sin(TETA)



//GRAficas para seguirodres de rodillo

TETA = TETA*180/(%pi)
plot(x,y)
scf
plot(TETA,phi*180/(%pi))
plot(TETA,TETA*0+30)
plot(TETA,TETA*0-30)

scf
plot(TETA,rho)

//GRAficas para seguirodres de cara plana

