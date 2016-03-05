function [fessura_nei_beams] = check_closure(M,N,h,q,fessura_nei_beams,ipsilon)
%csi_star=0;

for i=1:17
    if(fessura_nei_beams(i))~=0
        e=abs(M(i)/N(i));
        g=(1.99*ipsilon.^(1/2)-0.41*ipsilon.^(3/2)+18.7*ipsilon.^(5/2)-38.48*ipsilon.^(7/2)+53.85*ipsilon.^(9/2))/(6*(1.99*ipsilon.^(1/2)-2.47*ipsilon.^(3/2)+12.97*ipsilon.^(5/2)-23.17*ipsilon.^(7/2)+24.8*ipsilon.^(9/2)))-e/h;
        risultato=solve(subs(g),ipsilon);
        for k=1:max(size(risultato))
            if isreal(risultato(k))==1&&double(risultato(k))>0&&double(risultato(k))<1&&fessura_nei_beams(i)>double(risultato(k))
                fprintf('Chiudo fessura %f al valore %f sotto il carico %f\n\n',fessura_nei_beams(i), double(risultato(k)), q);
                fessura_nei_beams(i)=double(risultato(k));
                %csi_star=double(risultato(k));
            end
        end            
    end
end

