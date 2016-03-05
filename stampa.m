function []=stampa(risultati,plot_index,q_classic,q_crushing,q_fracturing,E,K1C,b,h,fc,ft,geometria)

fid = fopen('risultati.txt','a+');
fprintf(fid,'Rapporto freccia luce %s\n',geometria);
fprintf(fid,'Valore critico del fattore di intensificazione degli sforzi K1C = %.0f kg*cm^-(3/2)\n\n', K1C);
fprintf(fid,'Modulo di Young E = %.0fkg/cm^2\n',E);
fprintf(fid,'Sezione rettangolare di base %.0f cm e altezza %.0f cm\n',b,h);
fprintf(fid,'Resistenza a compressione fc = %.0f kg/cm^2\n',fc);
fprintf(fid,'Resistenza a trazione ft = %.0f kg/cm^2\n',ft);

fprintf(fid,' q(kg/cm)      N(kg)               Fc(-)          e(cm)            e/h(-)        csi(-)\n\n');
for i=1:plot_index-1    
    fprintf(fid,' %5.1f %16.2f %16.2f %15.2f %15.2f %15.4f\n',risultati(i).carico,risultati(i).axial,risultati(i).fc,...
            risultati(i).eccentricita,risultati(i).eccentricitasualtezza,max(risultati(i).beams_fessurati));     
end
fprintf(fid,'\n\n');
fprintf(fid,'Classic collapse under load %f kg/cm\n\n',q_classic);

if q_crushing~=0
    fprintf(fid,'Modified algorithm crushing collapse under load %f kg/cm\n\n',q_crushing);
    q_modified=q_crushing;
end

if q_fracturing~=0
    fprintf(fid,'Definitive fracture collapse under load %f kg/cm\n\n',q_fracturing);
    q_modified=q_fracturing;
end

rapporto=q_modified/q_classic;
fprintf(fid,'Classic c load / modified collapse load = %f\n\n\n\n\n',rapporto);

fclose(fid);

      