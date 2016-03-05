function [M,N]=fem(x,y,q,E,I,A,stiffness)

%Initializations 
rigidezza_definitiva=zeros(51,51);	q_definitiva=zeros(51,1);	indice=1;

%Ciclo spostamenti
for k=1:16

	L=sqrt((x(k+1)-x(k))^2 + (y(k+1)-y(k))^2);
	alpha=atan((y(k+1)-y(k))/(x(k+1)-x(k)));
    assemblaggio=zeros(51,6);
      

	kloc =     (E*I).*[	4/L		,	-6/L^2		,	0           ,	2/L		,	6/L^2	,	0;
                      -6/L^2	,	12/L^3		,	0           ,	-6/L^2	,	-12/L^3	,	0;
                    	0		,	0			,	A/(I*L) 	,	0		,	0		,	-A/(I*L);
                    	2/L		,	-6/L^2		,	0           ,	4/L		,	6/L^2	,	0;
                    	6/L^2	,	-12/L^3		,	0           ,	6/L^2	,	12/L^3	,	0;
                    	0		,	0			,	-A/(I*L)	,	0		,	0		,	A/(I*L)];		 	

	rot = [		1,		0,			0,              0,		0,              0;
				0,	cos(alpha),     sin(alpha), 	0,      0,              0;
				0,	-sin(alpha),	cos(alpha), 	0,      0,              0;
				0,		0,			0,              1,		0,              0;
				0,		0,			0,              0,      cos(alpha), 	sin(alpha);
				0,		0,			0,              0,  	-sin(alpha),	cos(alpha)];
                    
    if stiffness(k)~=0
        %Moltiplico *EI non refresha
        kloc(1,1)=E*I*(3*E*I+4*L*stiffness(k))/(L*(E*I+L*stiffness(k)));
        kloc(1,4)=E*I*(3*E*I+2*L*stiffness(k))/(L*(E*I+L*stiffness(k)));
        kloc(4,1)=E*I*(3*E*I+2*L*stiffness(k))/(L*(E*I+L*stiffness(k)));
        kloc(4,4)=E*I*(3*E*I+4*L*stiffness(k))/(L*(E*I+L*stiffness(k)));
    end
    
	kglob = rot'*kloc*rot;
	%Carico equivalente nodale
	Q=[-(q*312.5^2)/12,q*312.5/2,0,   (q*312.5^2)/12,q*312.5/2,0]';
	%Matrice assemblaggio
    switch k        
       case 1
       assemblaggio(1:3,4:6)=eye(3);
       assemblaggio(46:48,1:3)=eye(3);
       case 16
       assemblaggio(43:45,1:3)=eye(3);
       assemblaggio(49:51,4:6)=eye(3);
       otherwise
       assemblaggio(indice:indice+5,1:6)=eye(6);
       indice=indice+3;
    end
    
    %Assemblaggio carico
    q_definitiva=q_definitiva+assemblaggio*Q;
	%Assemblaggio rigidezza
	rigidezza_definitiva=rigidezza_definitiva+assemblaggio*kglob*assemblaggio';
end

spostamenti_ll=rigidezza_definitiva(1:45,1:45)\q_definitiva(1:45);

%PROVA
%reazioni=rigidezza_definitiva(46:51,1:45)*spostamenti_ll-q_definitiva(46:51);
%[reazione1,reazione2]=calcolo_reazioni(reazioni,x,y);
%FINE PROVA

%Ciclo calcolo MTN per ciascuna trave 
MTN=zeros(102,1); indice=1; spostamenti_LL=zeros(51,1); spostamenti_LL(4:48)=spostamenti_ll(1:45); index=1;
for k=1:16

	L=sqrt((x(k+1)-x(k))^2 + (y(k+1)-y(k))^2);
	alpha=atan((y(k+1)-y(k))/(x(k+1)-x(k)));
    
	kloc =     (E*I).*[	4/L		,	-6/L^2		,	0           ,	2/L		,	6/L^2	,	0;
                      -6/L^2	,	12/L^3		,	0           ,	-6/L^2	,	-12/L^3	,	0;
                    	0		,	0			,	A/(I*L) 	,	0		,	0		,	-A/(I*L);
                    	2/L		,	-6/L^2		,	0           ,	4/L		,	6/L^2	,	0;
                    	6/L^2	,	-12/L^3		,	0           ,	6/L^2	,	12/L^3	,	0;
                    	0		,	0			,	-A/(I*L)	,	0		,	0		,	A/(I*L)];
                    
	rot = [		1,		0,			0,              0,		0,              0;
				0,	cos(alpha),     sin(alpha), 	0,      0,              0;
				0,	-sin(alpha),	cos(alpha), 	0,      0,              0;
				0,		0,			0,              1,		0,              0;
				0,		0,			0,              0,      cos(alpha), 	sin(alpha);
				0,		0,			0,              0,  	-sin(alpha),	cos(alpha)];
            
    if stiffness(k)~=0
        %Moltiplico *EI non refresha
        kloc(1,1)=E*I*(3*E*I+4*L*stiffness(k))/(L*(E*I+L*stiffness(k)));
        kloc(1,4)=E*I*(3*E*I+2*L*stiffness(k))/(L*(E*I+L*stiffness(k)));
        kloc(4,1)=E*I*(3*E*I+2*L*stiffness(k))/(L*(E*I+L*stiffness(k)));
        kloc(4,4)=E*I*(3*E*I+4*L*stiffness(k))/(L*(E*I+L*stiffness(k)));
    end
        
    spostamenti_locali=rot*spostamenti_LL(indice:indice+5,1);
    Q=[-(q*312.5^2)/12,q*312.5/2,0,   (q*312.5^2)/12,q*312.5/2,0]';
    MTN_singola=kloc*spostamenti_locali-rot*Q;
    MTN(index:index+5,1)=MTN_singola(1:6);
    indice=indice+3;
    index=index+6;
end
%Arco simmetrico, se vuoi migliora. A questo punto in MTN hai gli sforzi
%agli estremi di ogni beam, visti sia da destra sia da sinistra:
%lenght(MTN)=2*num.beam
indice=1;
M=zeros(17,1); N=zeros(17,1); T=zeros(17,1);
for k=1:6:54
    M(indice)=-MTN(k);
    T(indice)=MTN(k+1);
    N(indice)=-abs(MTN(k+2));
    indice=indice+1;
end
N(10)=N(8);
N(11)=N(7);
N(12)=N(6);
N(13)=N(5);
N(14)=N(4);
N(15)=N(3);
N(16)=N(2);
N(17)=N(1);
M(10)=M(8);
M(11)=M(7);
M(12)=M(6);
M(13)=M(5);
M(14)=M(4);
M(15)=M(3);
M(16)=M(2);
M(17)=M(1);


