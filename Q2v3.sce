// -----------------------------------------------------------------
// Code name : Animador de mecanismo.
// Topic:      Analisis de posiciones.
// Author:     Jose A. Martines T.
// Copyright (C) 2019 
// Date of creation: 11/03/2019
// -----------------------------------------------------------------




//___________________________________________________________________


function grafica(ptos,MC,teta,e)
    np=max(size(ptos));
    ne=max(size(MC));

    for i=1:ne
        nn=nnz(MC(i,:))
        if nn==3 then 
            x=ptos(MC(i,:),1);
            y=ptos(MC(i,:),2);
            T=[1 1 2 3 1];
            z=ones(x)*1
            fec(x,y,T,z,strf="060",colminmax=[-10,50]);
            //gcf().color_map = jet(50);
        elseif nn==2
             
            plot(ptos(MC(i,1:2),1),ptos(MC(i,1:2),2),'k','LineWidth',10);
            //gcf().color_map = jet(64);
        else
            x=ptos(MC(i,1),1);
            y=ptos(MC(i,1),2);
            MR=[cosd(teta(i)) -sind(teta(i));sind(teta(i)) cosd(teta(i))];
            cor=MR*[-slider(1) -slider(1) slider(1) slider(1);slider(2) -slider(2) slider(2) -slider(2)];
            T3=[1 1 2 4 1;1 1 3 4 4];
            z=ones(cor(1,:))*-10;
            fec(cor(1,:)+x,cor(2,:)+y,T3,z,strf="060",colminmax=[-10,50]);
            //gcf().color_map = jet(64);
        end
    end

    for i=1:np
        plot(ptos(i,1),ptos(i,2),'o');
        h_compound = gce();
        h_compound.children.mark_size = e;
    end

endfunction




function ig(Tierra,nv,MC,ptosg,tetasg,e,TAV)

nt=max(size(Tierra))
k=0
kk=1
np1=max(size(TAV))
np2=max(size(ptosg(1,2,:)))
for m=1:nv

    for i=1:j-1

        drawlater();
        clf

        k=k+kk;

        grafica(ptosg(:,:,k),MC,tetasg(:,k),e)

        //Traza escala de ventana
        plot2d(11/10*max(ptosg(:,1,:)),11/10*max(ptosg(:,2,:)),-1)
        plot2d(11/10*min(ptosg(:,1,:))-1/10*max(ptosg(:,1,:)),11/10*min(ptosg(:,2,:))-1/10*max(ptosg(:,2,:)),-1)
        //Traza tierras
        for jj=1:nt
            n=Tierra(jj);
            plot(ptosg(n,1,i),ptosg(n,2,i),"+");
            h_compound = gce();
            h_compound.children.mark_size = 30;
        end
        //Trayectorias
        
        if TAV<>0 then
            for ii=1:np1
                ij=TAV(ii)
                plotx(1:np2)=ptosg(ij,1,:)
                ploty(1:np2)=ptosg(ij,2,:)
                plot(plotx,ploty)
            end
        end
        
        //Calculo de centrodos
//        for ii=1:length(CTDS)/2
//            p1=[ptosg(MC(CTDS(ii,1),1),:,k);ptosg(MC(CTDS(ii,1),2),:,k)]
//            p2=[ptosg(MC(CTDS(ii,2),1),:,k);ptosg(MC(CTDS(ii,2),2),:,k)]
//
//            // m1x+b1=m2x+b2
//            
//            m1=atand((p1(1,2)-p1(2,2))/(p1(2,2)-p1(2,2)))
//            m2=atand((p2(1,2)-p2(2,2))/(p2(2,2)-p2(2,2)))
//            b1=p1(1,2)-m1*p1(1,1)
//            b2=p2(1,2)-m2*p2(1,1) 
//            x0(k)=(b1-b2)/(m2-m1)
//            y0(k)=m2*x0(i)+b2
//            plot(x0/10,y0/10)
//            plot([p1(:,1); x0(k)],[p1(:,2); y0(k)])
//            plot([p2(:,1); x0(k)],[p2(:,2); y0(k)])
//        end
//        
        isoview
        drawnow();
    end
    
    //Decide si realiza retorno o contiua el ciclo
    if max(tetasg)==360 | max(tetasg)>360 then
        k=0
    else
        kk=kk*-1
        if kk<0 then 
            k=j;
        else
            k=0;
        end
    end
end
endfunction
