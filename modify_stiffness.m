function [stiffness_16] = modify_stiffness(stiffness)
%Trasforma stiffness da 17*1 a 16*1 eliminando l'elemento 5
stiffness_16=zeros(16,1);
for i=1:4
    stiffness_16(i)=stiffness(i);
end
 
for i=6:16
    stiffness_16(i)=stiffness(i+1);
end
 

