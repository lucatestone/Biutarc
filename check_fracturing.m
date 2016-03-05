function [fessura_nei_beams,fracturing_collapse,e,Fc_max]=check_fracturing(M,N,A,b,h,I,ft,K1C,fessura_nei_beams,ics)
%Hai inizializzato e perchè se non scatta il controllo della fessurazione
%non restituiresti niente, Fc è solo crescente vero?
fracturing_collapse=0; e=abs(max(M)/max(N)); Fc=zeros(17,1); Fc_max=0;

    for i=1:17
        if abs(M(i))*h/(2*I)+N(i)/A>ft 
            Fc(i)=-N(i)/(sqrt(h)*b*K1C);
            e=abs(M(i)/N(i));
            f=1/((e/h)*6*(1.99*ics^(1/2)-2.47*ics^(3/2)+12.97*ics^(5/2)-23.17*ics^(7/2)+24.8*ics^(9/2))-(1.99*ics^(1/2)-0.41*ics^(3/2)+18.7*ics^(5/2)-38.48*ics^(7/2)+53.85*ics^(9/2)))-Fc(i);
            soluzione=solve(subs(f),ics);
            fessura=zeros(max(size(soluzione)),1);
            for k=1:max(size(soluzione))
                if isreal(soluzione(k))==1&&double(soluzione(k))<1&&double(soluzione(k))>0
                    fessura(k)=soluzione(k);
                    %check definitive fracture collapse
                    if fessura(k)>0.7
                        fracturing_collapse=1;
                        fessura_nei_beams(i)=fessura(k);
                        return
                    end
                end
            end        
            fessura=sort(fessura,'descend'); 
            if fessura(1)>fessura_nei_beams(i)
                fessura_nei_beams(i)=fessura(1);
            end
       
        end    
    end    
    Fc_max=max(Fc);