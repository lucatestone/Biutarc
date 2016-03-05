This MatLab program computes and compares both elastic crushing collapse load for an arched structure, and the critical load for the same arch taking into account the fracturing evolutive progress (using Linear Elastic Fracture Mechanics theory).
To use the program, you have to operate from biutarc.m file. You have to pass to it two variables: 

%freccia_su_luce (float) = rise over span ratio of the arch

%geometria (string) = name of the model you want to be printed in the txt output file

Then define mechanichal properties of the material in the 5th line of the biutarc.m file
The geometry of the arch (5000cm in span default) is defined as the circle passing by three points: (0,0) (span/2,rise) (span,0).
Results will be saved in a 'risultati.txt' text file (in MatLab's current directory).
Details and tutorial will come as my publication goes online, this is a raw version of the program which need polishment.
