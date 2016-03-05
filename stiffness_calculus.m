function [stiffness]=stiffness_calculus(fessura_nei_beams,E,b,h)
%Calcola la modifica della rigidezza dovuta alla fessurazione nel beam.
stiffness=zeros(17,1);
for i=1:17
    if fessura_nei_beams(i)~=0
        Ym_alquadrato=@(t) 36*(1.99*t.^(1/2) - 2.47*t.^(3/2) + 12.97*t.^(5/2) - 23.17*t.^(7/2) + 24.8*t.^(9/2)).^2;
        stiffness(i)=((h^2)*b*E)/(2*integral(Ym_alquadrato,0,fessura_nei_beams(i)));
    end

end

