%% Combinación de rotaciones

% Rotación en el eje Z
syms gama
gama = pi/2;

rotz = [cos(gama) -sin(gama) 0 0; ...
        sin(gama)  cos(gama) 0 0; ...
        0         0         1 0; ...
        0         0         0 1]

%% Rotación en el eje X
syms alfa
alfa = pi/2;

rotx = [1 0         0          0; ...
        0 cos(alfa) -sin(alfa) 0; ...
        0 sin(alfa)  cos(alfa) 0; ...
        0 0         0          1]

%% Definimos el punto
p = [3 0 0 1]'

%% Aplicamos ambas rotaciones (Z luego X) estaba al revés 
RT = rotx * rotz


%%
RT*p

% EL ORDEN CON EL QUE HACEMOS LAS ROTACIONES SI IMPORTA ver apunte

%% PROBAREMOS HACER LAS ROTACIONES AL REVÉS 

RTT = rotz * rotx

RTT*p

