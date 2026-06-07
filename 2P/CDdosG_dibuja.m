%% ===============================================================
% FK 2R (cinemática directa de un manipulador planar de 2 eslabones)
% ---------------------------------------------------------------
% Modelo:
%  - Eslabón 1: longitud l1
%  - Eslabón 2: longitud l2
%  - Articulaciones: q1 (hombro), q2 (codo), en RADIANES
%  - Punta (end-effector) en el plano XY: (x, y)
%
% Ecuaciones:
%   x = l1*cos(q1) + l2*cos(q1 + q2)
%   y = l1*sin(q1) + l2*sin(q1 + q2)
%
% Sugerencia docente:
%  - Probá distintos q1, q2 para ver cómo cambia (x,y).
%  - OJO: sin/cos usan radianes (usa deg2rad si trabajás en grados).
% ===============================================================

close all; clear; clc;
format bank     % Muestra con 2 decimales (útil para no ver "ruido" numérico)

%% Parámetros geométricos (metros)
l1 = 0.70
l2 = 0.30

%% Ángulos articulares (RADIANES)
% Cambiá estos valores para probar.
q1 = pi*2       % por ej.: q1 = pi/4;
q2 = pi/2        % por ej.: q2 = -pi/6;

%% Cinemática directa (FK)
x = l1*cos(q1) + l2*cos(q1 + q2)
y = l1*sin(q1) + l2*sin(q1 + q2)

%% Mostrar resultados numéricos
disp('--- FK 2R (planar) ---'); %% forward kinematic en ingles 
fprintf('q1 = %.4f rad, q2 = %.4f rad\n', q1, q2);
fprintf('x  = %.2f m,   y  = %.2f m\n', x, y);

%% (Opcional) Dibujo del brazo para visualizar
% Puntos clave:
O  = [0; 0];                            % origen
P1 = [l1*cos(q1);         l1*sin(q1)];  % codo
P2 = [x;                   y];          % punta

figure('Name','FK 2R - Visualización');
plot([O(1) P1(1) P2(1)], [O(2) P1(2) P2(2)], '-o', ...
     'LineWidth', 2, 'MarkerFaceColor', [0.9 0.4 0.1], 'MarkerSize', 7);
grid on; axis equal; hold on;
xlabel('X [m]'); ylabel('Y [m]');
title('Brazo 2R en el plano XY (FK)');

% Marcas y etiquetas
scatter(0,0,60,[1 0 1],'filled','Marker','p','DisplayName','Origen (0,0)');
text(P1(1), P1(2), '  Codo'); text(P2(1), P2(2), '  EFinal');

% Limites de la vista (~radio l1+l2 y margen)
R = l1 + l2;  m = 0.1;
xlim([-R-m, R+m]); ylim([-R-m, R+m]);

legend({'Eslabones + Juntas'},'Location','best');
