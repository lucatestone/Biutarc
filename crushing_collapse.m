function [crush]=crushing_collapse(M, N, h, fc, I, A)
%fc viene passata in modulo
crush=0;

for i=1:17
    if abs(M(i))*h/(2*I)+abs(N(i))/A>fc
        crush=1;
    end
end
