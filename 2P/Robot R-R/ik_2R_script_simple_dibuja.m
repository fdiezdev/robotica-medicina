%% ===============================================================
% IK 2R (doble solución) + DIBUJO de ambas configuraciones
% ---------------------------------------------------------------
% - Misma lógica y variables que tu función original (en GRADOS)
% - Muestra las 2 soluciones [q1 q2] y las DIBUJA con colores distintos
% ===============================================================

close all; clear all; clc;
format bank

%% --- Parámetros geométricos (m) ---
l1 = 0.70
l2 = 0.30

%% --- Punto objetivo (x,y) ---
% Editá este valor para probar:
p = [0.70; 0.60];     % <-- objetivo
x = p(1);
y = p(2);

%% --- IK 2R (en GRADOS)
argCos = (x^2 + y^2 - l1^2 - l2^2) / (2 * l1 * l2);
if (abs(argCos) > 1)
    argCos = sign(argCos);
    disp('Cuidado! Argumento del coseno > 1')
end

q2(1) = -acosd(argCos);
q2(2) =  acosd(argCos);

q1(1) = atan2d(y, x) - atan2d(l2 * sind(q2(1)) , (l1 + l2 * cosd(q2(1))));
q1(2) = atan2d(y, x) - atan2d(l2 * sind(q2(2)) , (l1 + l2 * cosd(q2(2))));

q = [q1' q2'];   % (2x2) filas = soluciones, columnas = [q1 q2]

%% --- Mostrar soluciones ---
disp('Soluciones [q1  q2] en grados (fila=solución):');
disp(q);

%% --- Preparar dibujo ---
figure('Name','IK 2R - Dos soluciones');
axis equal; grid on; hold on;
xlabel('X [m]'); ylabel('Y [m]');

R = l1 + l2; m = 0.1;
xlim([-R-m, R+m]); ylim([-R-m, R+m]);

% Origen y objetivo
scatter(0,0,80,[1 0 1],'filled','Marker','p','DisplayName','Origen (0,0)');
scatter(x,y,70,[0.85 0.33 0.1],'filled','MarkerEdgeColor','k','DisplayName','Objetivo');

%% --- FK para cada solución (en GRADOS) y dibujo ---

% --- Solución 1 (codo "abajo") en CELESTE ---
x1 = l1*cosd(q1(1));     y1 = l1*sind(q1(1));
x2 = x1 + l2*cosd(q1(1) + q2(1));
y2 = y1 + l2*sind(q1(1) + q2(1));
plot([0 x1 x2], [0 y1 y2], '-o', 'LineWidth', 2, ...
     'MarkerFaceColor',[0.9 0.4 0.1], 'MarkerSize', 7, ...
     'Color',[0 0.45 0.74], 'DisplayName', ...
     sprintf('Sol 1: q1=%.2f°, q2=%.2f°', q1(1), q2(1)));
text(x2, y2, '  Punta S1','Color',[0 0.45 0.74]);

% --- Solución 2 (codo "arriba") en VERDE ---
x1b = l1*cosd(q1(2));    y1b = l1*sind(q1(2));
x2b = x1b + l2*cosd(q1(2) + q2(2));
y2b = y1b + l2*sind(q1(2) + q2(2));
plot([0 x1b x2b], [0 y1b y2b], '-o', 'LineWidth', 2, ...
     'MarkerFaceColor',[0.9 0.4 0.1], 'MarkerSize', 7, ...
     'Color',[0 0.6 0], 'DisplayName', ...
     sprintf('Sol 2: q1=%.2f°, q2=%.2f°', q1(2), q2(2)));
text(x2b, y2b, '  EFinal','Color',[0 0.6 0]);

legend('Location','best');
title('Cinemática Inversa 2R - Dibujo de las dos soluciones');
