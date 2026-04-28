%% Script de rotación de un punto 
% Se tiene un punto en el espacio XYZ, definido por el vector x,y,z
clear all; close all; clc
x = input("\n Seleccione el valor de x: ");
y = input("\n Seleccione el valor de y: ");
z = input("\n Seleccione el valor de z: ");
gama = input("\n ¿Cuántos grados desea rotar?[0°;360°]: ");
gama = deg2rad(gama);

p = [x y z 1]'   % punto a rotar

% Definimos sobre que eje se rota
select = input("\n ¿En que eje desea rotar? (0 = x, y = 1, z = 2) : ");

while select ~= 0 && select ~= 1 && select ~= 2
    fprintf("¡Elija un valor válido!")
    select = input("\n ERROR ¿En que eje desea rotar? (0 = x, y = 1, z = 2) : ");
end

syms theta real    % valores simbólicos para indicar cuanto rota cada eje
rot = []            % matriz de rotación

if select == 2
    % rotación en el eje z
    rot = [ cos(theta)  -sin(theta) 0   0;...
            sin(theta)  cos(theta) 0   0;...
            0   0   1   0;...
            0   0   0   1]
elseif select == 1
    % Rotación en el eje y
    rot = [ cos(theta)  0   sin(theta)   0;...
            0   1   0   0;...
            -sin(theta)   0   cos(theta)   0;...
            0   0   0   1]
else
    % rotación en el eje x
    rot = [ 1  0   0   0;...
            0   cos(theta)   -sin(theta)   0;...
            0   sin(theta)   cos(theta)   0;...
            0   0   0   1]
end

theta = gama
rot_mat = eval(rot)   % evaluamos la matriz de rotación en el ángulo

% realizamos el producto vectorial para obtener la nueva coordenada
pp = rot_mat * p

%%
fprintf("\n El punto P = (%.2f,%.2f,%.2f) rotado en el eje es P'=(%.2f,%.2f,%.2f)", x,y,z,pp(1),pp(2),pp(3))