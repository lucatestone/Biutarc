function [ x,y ] = coordinate( freccia_su_luce )
%Fissata la luce L,geometria circolare, input freccia [cm] output
%coordinate [cm]
%  Cerchio passante per tre punti (0,0; luce/2,freccia; luce,0), di cui
%  viene esplicitata la y; fissati 17 punti x a passo costante, luce/17,
%  sostituisci nell'equazione e hai le y
x=zeros(17,1);
y=zeros(17,1);
L=5000; 
freccia=freccia_su_luce*L;
a=-L;
b=(-(freccia^2)+(L^2)/4)/freccia;

f= @(x) (-b+sqrt(b^2-4*(x^2+a*x)))/2;
passo=L/16;
for i=2:17
    x(i)=x(i-1)+passo;
    y(i)=f(x(i));
end

