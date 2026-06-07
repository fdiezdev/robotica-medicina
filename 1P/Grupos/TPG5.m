clc;
clear;
close all;

%% Parametros del robot - Longitudes
L=2 
L1=2

%% Cinematica Directa - Buscamos la posicion del TCP a partir de los angulos

%Ingresamos el valor de tita 1
tita1 = input('Introduzca el valor de tita 1 (0 a 180°): ');

%Chequeamos que este dentro del rango
while (tita1 <= 0 || tita1 >= 180) % Validamos si está fuera del rango
    tita1 = input('VALOR INVALIDO. Introduzca tita 1 entre 0 y 180°: ');
end
tita1_rad = deg2rad(tita1)
    
%Ingresamos el valor de tita 2
tita2 = input('Introduzca el valor de tita 2 (0 a 180°): ');

% Chequeamos que este dentro del rango
while (tita2 <= 0 || tita2 >= 180)
    tita2 = input('VALOR INVALIDO. Introduzca tita 2 entre 0 y 180°: ');
end
tita2_rad = deg2rad(tita2)

%Calculamos las coordenadas de la posicion del TCP
fprintf('La posicion del TCP es: ');
z = L - (L1*cos(tita1_rad))
y = L1*sin(tita2_rad)*sin(tita1_rad)
x = L1*cos(tita2_rad)*sin(tita1_rad)

%% Cinematica Indirecta - Buscamos los datos de la articulacion con coordenadas

x1 = input('Introduzca el valor de x entre -2 y 2: ');
while (x1>2||x1<-2)
    x1 = input('ERROR - Introduzca el valor de x entre -2 y 2: ');
end

y1 = input('Introduzca el valor de y entre 0 y 2: ');
while (y1>2||y1<0)
    y1 = input('ERROR - Introduzca el valor de y entre 0 y 2: ');
end

z1 = input('Introduzca el valor de z entre 0 y 4: ');
while (z1>4||z1<0)
    z1 = input('ERROR - Introduzca el valor de z entre 0 y 4: ');
end

%Calculamos la distancia desde la articulación (0,0,L) hasta el punto

distancia_al_punto = sqrt(x1^2 + y1^2 + (z1 - L)^2);

%Chequeamos
while abs(distancia_al_punto - L1) > 0.01
    disp('ERROR: El punto no pertenece al area de trabajo del robot.');
    disp('Vuelva a introducir valores: ');
    x1 = input('Introduzca el valor de x entre 0 y 2: ');
    y1 = input('Introduzca el valor de y entre 0 y 2: ');
    z1 = input('Introduzca el valor de z (0 a 4): ');
    distancia_al_punto = sqrt(x1^2 + y1^2 + (z1 - L)^2);
end

%Buscamos los theta
theta2 = atan2(y1,x1) 
theta2_deg = rad2deg(theta2)
theta1 = atan2((sqrt((x1^2)+(y1^2))),(L-z1))
theta1_deg = rad2deg(theta1)

%% Grafico del Robot
figure(1);
% Definimos los puntos clave
% P0: Origen (Base)
% P1: Articulacion (Tope de L)
% P2: TCP (Efector final)
P0 = [0, 0, 0];
P1 = [0, 0, L];
P2 = [x, y, z]; % Usa los valores calculados en la CD o CI

% Dibujamos los eslabones como lineas gruesas
plot3([P0(1) P1(1)], [P0(2) P1(2)], [P0(3) P1(3)], 'm', 'LineWidth', 3); hold on;
plot3([P1(1) P2(1)], [P1(2) P2(2)], [P1(3) P2(3)], 'c', 'LineWidth', 3);

% Dibujamos las articulaciones como esferas/puntos
plot3(P0(1), P0(2), P0(3), 'ko', 'MarkerFaceColor', 'k');
plot3(P1(1), P1(2), P1(3), 'ko', 'MarkerFaceColor', 'k');
plot3(P2(1), P2(2), P2(3), 'ro', 'MarkerFaceAlpha', 0.5); % El TCP en rojo

% Configuracion de la vista
grid on;
axis([-2.5 2.5 -2.5 2.5 0 4.5]); % Limites de los ejes
xlabel('Eje X (m)'); ylabel('Eje Y (m)'); zlabel('Eje Z (m)');
title('Visualización del Robot RR');
legend('Eslabón L (Fijo)', 'Eslabón L1 (Móvil)', 'TCP');
view(45, 30); % Cambia el angulo de vision
rotate3d on; % Permite rotar el grafico con el mouse

%%




































