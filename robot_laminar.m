%% Limpio entorno
clear all;
close all;
clc;
%% Definición del problema
% Robot Laminar R-R
% Condiciones de diseño:
%   - L y L1 tienen valores determinados
%   - theta1 y theta2 deben estar entre 0 y 180°
L = 2   % Longitud del primer link [m]
L1 = 2  % Longitud del segudo link [m]

% ingresamos los datos de los ángulos
theta1 = input("Ingrese el valor de tita1 en °: ")
theta2 = input("Ingrese el valor de tita1 en °: ")

% validamos que los ángulos estén dentro de los límites de diseño:
if(theta1 <= 0 || theta1 >= 180)
    error("El valor de theta 1 no puede ser mayor a 180° o menor a 0°")
end

if(theta2 <= 0 || theta2 >= 180)
    error("El valor de theta 1 no puede ser mayor a 180° o menor a 0°")
end
% Pasamos a todo a radianes
theta1_rad = deg2rad(theta1)
theta2_rad = deg2rad(theta2)

% una vez tenemos los datos podemos seguir con el cálculo. 
%% Cinemática directa
% Buscamos encontrar la posición del TCP en (x,y,z) en base a los ángulos
% introducidos

alpha = theta1_rad - (pi/2) % angulo auxiliar entre link 2 y el fijo

d = L1 * sin(alpha)

% Defino el primer valor de cinemática directa
Z = L + (L1*sin(alpha))
Y = L1 * cos(alpha) * sin(theta2_rad)
X = L1 * cos(alpha) * cos(theta2_rad)

fprintf('Valores de cinemática directa (x,y,z) = (%.2f, %.2f, %.2f)', X,Y,Z)
%% Cinemática inversa
% Buscamos la posición de los ángulos en base a los X,Y,Z

% El usuario debe ingresar la posición del robot
x = input("\n Ingrese valor de coordenada en eje X[m]: ")
y = input("\n Ingrese valor de coordenada en eje Y[m]: ")
z = input("\n Ingrese valor de coordenada en eje Z[m]: ")

% Verificamos que los valores sean válidos 
if z < 0
    error("La coordenada Z no puede ser negativa")
    
% Verificamos que las coordenadas estén dentro del área de trabajo del
% robot
check = (x^2)+(y^2)+((z-L)^2)
if check > (L1^2)
    error("Las coordenadas seleccionadas están fuera del área de trabajo del robot, ingrese de nuevo")
end

% Buscamos los valores
theta2_inv = atan(y/x)
theta1_inv = atan((-sqrt((x^2) + (y^2)))/(z - L))

fprintf('Valores de cinemática inversa (?1, ?2) = (%.2f, %.2f)', theta1_inv, theta2_inv);
