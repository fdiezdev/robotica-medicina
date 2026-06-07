%% MATRIZ DE TRASLACIÓN 

% Definimos la variable simbólica para el desplazamiento en x (dx)
syms dx

% Limpiamos el espacio de trabajo, cerramos todas las ventanas y limpiamos la consola
close all; clear all; clc

% Definimos desplazamientos simbólicos en los tres ejes
syms dx dy dz real 

% Creamos la matriz de traslación en el espacio
tras = [1 0 0 dx; ... % Desplazamiento en el eje X
        0 1 0 0; ...  % No hay desplazamiento en Y
        0 0 1 0; ...  % No hay desplazamiento en Z
        0 0 0 1]     % Parte homogénea de la matriz

%% Asignamos un valor a dx = 3
dx = 3;

% Evaluamos la matriz de traslación con dx = 3
eval(tras)

%% Definimos una nueva matriz de traslación tras1
tras1 = [1 0 0 1; ...   % Desplazamiento en X = 1
         0 1 0 -6; ...  % Desplazamiento en Y = -6
         0 0 1 -7; ...  % Desplazamiento en Z = -7
         0 0 0 1]
    

%% Definimos un punto en el espacio en coordenadas homogéneas
p = [2 3 4 1]'  % Punto P en el espacio (2, 3, 4) más el 1 de la coordenada homogénea

%% Aplicamos la traslación al punto P
p1 = tras1 * p

%% MATRICES DE ROTACIÓN

% Limpiamos nuevamente el espacio de trabajo
close all; clear all; clc

% ROTACIÓN EN EL EJE Z
syms gama   % Ángulo de rotación en el eje Z

% Definimos la matriz de rotación en el eje Z
rotz = [cos(gama) -sin(gama) 0 0; ...  % Rotación en el plano X-Y
        sin(gama)  cos(gama)  0 0; ...
        0         0          1 0; ...  % Sin rotación en el eje Z
        0         0          0 1]

%% Asignamos un valor a gama = pi (180 grados)
gama = pi/2;

% Evaluamos la matriz de rotación con gama = pi/2
rotzz = eval(rotz)

%% Definimos un nuevo punto
p = [1.75 1.75 1.75 1]'  % Punto P en (3, 0, 0)
%%
% Aplicamos la rotación en Z al punto P
pp = rotzz * p

%% Otra rotación en Z pero con gama = -pi/2
close all; clear all; clc

gama = -pi/2;  % Ángulo de rotación negativo (hacia el sentido contrario)
rotz = [cos(gama) -sin(gama) 0 0; ...
        sin(gama)  cos(gama)  0 0; ...
        0         0          1 0; ...
        0         0          0 1]

p = [3 0 0 1]';  % Definimos el punto P de nuevo

%% Aplicamos la rotación
pp = rotz * p

%% ROTACIÓN EN EL EJE Y

close all; clear all; clc

syms beta  % Ángulo de rotación en el eje Y

% Definimos la matriz de rotación en el eje Y
roty = [cos(beta)  0 sin(beta) 0; ...  % Efecto de rotación en el plano Z-X
        0          1 0         0; ...
       -sin(beta)  0 cos(beta) 0; ...
        0          0 0         1]

%% Definimos el punto a rotar

p = [3 0 0 1]'

%% definimos el angulo beta: 
beta= pi/2

%% evaluamos la matriz de rotación en el eje y

rotyy= eval(roty)


%% Aplicamos la rotación en Y
pp = rotyy * p

%% ROTACIÓN EN EL EJE X

close all; clear all; clc

syms alfa  % Ángulo de rotación en el eje X

% Definimos la matriz de rotación en el eje X
rotx = [1 0         0          0; ...
        0 cos(alfa) -sin(alfa) 0; ...
        0 sin(alfa)  cos(alfa) 0; ...
        0 0         0          1]
%%
    
p = [1.75 1.75 1.75 1]'  % Definimos el punto P en el espacio

%% definimos el ángulo alfa 
alfa = pi/2

%% evaluamos la matriz de rotación con alfa 

rotxx= eval (rotx) 

%% Aplicamos la rotación en el eje X
pp = rotxx * p

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
p = [3 0 0 1]';

%% Aplicamos ambas rotaciones (X luego Z)
PP = rotx * rotz * p

%%

