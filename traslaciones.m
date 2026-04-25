%% Script de traslaciones 

clear all; close all; clc
% Ingresamos punto en el espacio
x = input("\n Seleccione el valor de x: ");
y = input("\n Seleccione el valor de y: ");
z = input("\n Seleccione el valor de z: ");

p = [x y z 1]'

% Definimos la matriz de traslación
syms dx dy dz real;

dx = input("¿cuanto en x?: ");
dy = input("¿cuanto en y?: ");
dz = input("¿cuanto en z?: ");

% Matriz de traslación
tr = [1 0   0   dx;...
      0 1   0   dy;...
      0 0   1   dz;...
      0 0   0   1]
  
pp = tr * p

fprintf("\n El punto P = (%.2f,%.2f,%.2f) trasladado P'=(%.2f,%.2f,%.2f)", x,y,z,pp(1),pp(2),pp(3))