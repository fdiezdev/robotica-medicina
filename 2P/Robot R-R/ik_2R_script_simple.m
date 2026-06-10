%% CINEMÁTICA INVERSA ROBOT 2 GDL (SCRIPT)
% -
% - Unidades en GRADOS (acosd, atan2d, sind, cosd)
% - Cambiá el punto objetivo 'p' acá abajo

close all; clear all; clc;
format bank   % números chicos como 0.00

%% Constantes
l1 = 0.70
l2 = 0.30

%% Punto objetivo (x,y) en el plano
% Cambiá este valor para probar:
p = [0.60; 0.20];   % <-- editar
x = p(1)
y = p(2)

%% Cálculo de la Cinemática Inversa (igual que tu función)
argCos = (x^2 + y^2 - l1^2 - l2^2) / (2 * l1 * l2);
if (abs(argCos) > 1)
    argCos = sign(argCos);
    disp('Cuidado! Argumento del coseno > 1')
end

q2(1) = -acosd(argCos);
q2(2) =  acosd(argCos);

q1(1) = atan2d(y, x) - atan2d(l2 * sind(q2(1)) , (l1 + l2 * cosd(q2(1))));
q1(2) = atan2d(y, x) - atan2d(l2 * sind(q2(2)) , (l1 + l2 * cosd(q2(2))));

q = [q1' q2']   % mismo formato que tu función (2 soluciones)

%% Mostrar resultado
disp('Soluciones [q1  q2] en grados (fila=solución):');
disp(q);
