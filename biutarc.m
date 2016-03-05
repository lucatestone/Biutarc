function [risultati]=biutarc(freccia_su_luce,geometria)
	%freccia_su_luce (float) = rise over span ratio of the arch
	%geometria (string) = name of the model you want to be printed in the txt output file
	%Parameters: constant for all beams
		E = 300000;	b=40;	h=80;		A = b*h;	I = (b*h^3)/12;		fc= -500;		ft=30;		K1C=100;    
	% 	{kg*cm^ -2}	{cm}	{cm}		{cm^2}		{cm^4}              {kg*cm^ -2}		{kg*cm^ -2}	{kg*cm^ -(3/2)}
    	[x,y] = coordinate(freccia_su_luce);
    
    %Linear elastic fem
    %Initializations
	crush=0; stiffness=zeros(16,1); q=1; 
    while crush==0 
        [M,N]=fem(x,y,q,E,I,A,stiffness); 
        crush=crushing_collapse(M, N, h, abs(fc), I, A);
        if 	crush==1
            q_classic=q;           
        end     
        %Load increase
        q=q+0.01;
    end
    disp(q_classic);
    
    %Evolutive fem analysis
    %Initializations
    crush=0; fracturing_collapse=0; q=1; fessura_nei_beams=zeros(17,1); plot_index=1; stiffness_16=zeros(16,1); q_crushing=0; q_fracturing=0; syms ics; syms ipsilon;
    while fracturing_collapse==0&&crush==0        
        disp(q);
        [M,N]=fem(x,y,q,E,I,A,stiffness_16);
        crush=crushing_collapse(M, N, h, abs(fc), I, A);
        
        if 	crush==1
            q_crushing=q;         
        else
            [fessura_nei_beams,fracturing_collapse,e,Fc_max]=check_fracturing(M,N,A,b,h,I,ft,K1C,fessura_nei_beams,ics);    
            [fessura_nei_beams] = check_closure(M,N,h,q,fessura_nei_beams,ipsilon); 
            if 	fracturing_collapse==1
                q_fracturing=q;
            else 
                [stiffness]=stiffness_calculus(fessura_nei_beams,E,b,h);
                [stiffness_16] = modify_stiffness(stiffness);
            end
        end
        
        
        risultati(plot_index).carico=q;
        risultati(plot_index).axial=max(N);
        risultati(plot_index).eccentricita=e;
        risultati(plot_index).fc=Fc_max;
        risultati(plot_index).eccentricitasualtezza=e/h;
        risultati(plot_index).beams_fessurati=fessura_nei_beams;
        %risultati(plot_index).fessura_chiusa=csi_star;
      
        %Load increase
        if plot_index<(q_classic/0.5)-2
            q=q+0.5;
        else
            q=q+0.1;
        end
        plot_index=plot_index+1; 
    end
    
    stampa(risultati,plot_index,q_classic,q_crushing,q_fracturing,E,K1C,b,h,fc,ft,geometria);