%% Drone visto desde torre de control
clear all; close all; clc;

% variable_D hace referencia a que la coordenada está expresada 
% con respecto al sistema coordenado del drone. _T con respecto a la torre.
%% Definición de parámetros
p_control_D = [30 100 -20 1]';  % pos. de la torre de control en coordenadas del drone
q = pi;                         % rotación del sistema de la torre con respecto al drone
p_tecnico_T = [2 -3 0 1]'       % posición del técnico con respecto a la torre de control
p_objeto_D = [25 110 -15 1]'    % posición del objeto en el espacio con respecto al drone
%% Consigna A
% construir una matriz homogénea (H) para los parámetros definidos
% esta matriz me permite pasar un punto expresado en coordenadas de la
% torre en coordenadas expresadas en el sistema del drone

% el componente traslacional de la matriz va a ser p_control_D
Tsist = [1  0   0   p_control_D(1);
         0  1   0   p_control_D(2);
         0  0   1   p_control_D(3);
         0  0   0   1;
    ];

% el componente rotacional va a ser una matriz de rotación en el eje Z

Rz = [ cos(q)  -sin(q)   0  0;
       sin(q)   cos(q)   0  0;
       0    0   1   0;
       0    0   0   1];
% Luego la matriz de transformación homogenea será:
% OJO: ver que hace primero si rotación o traslación, puede ser diferente
%   - si primero rota y despues traslada: Tsist*Rz
%   - si primero traslada y despues rota: Rz*Tsist
H = Tsist * Rz
%% Ejercicio B
% se pide calcular la posición del técnico vista desde el sistema del drone
% para eso calculamos:
p_tecnico_D = H * p_tecnico_T

%% Ejercicio C
% se pide calcular la matriz inversa de H
H_inv = inv(H)
%% Ejercicio D
% se pide verificar que el producto entre la matriz inversa y la matriz
% original da como resultado la identidad
I = H_inv * H

%% Ejercicio E
% se pide calcular la posición del objeto detectado por el drone pero
% expresada en coordenadas de la torre de control
p_objeto_T = H_inv * p_objeto_D

%% Ejercicio F
% usar la matriz H implica pasar una coordenada expresada en el sistema de
% la torre de control al sistema del drone

% usar la matriz H_inv implica pasar una coordenada expresada en el sistema
% del drone a coordenadas del sistema de la torre de control