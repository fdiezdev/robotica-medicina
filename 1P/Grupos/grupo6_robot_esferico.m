%% ========================================================================
%% ROBÓTICA EN MEDICINA
%% CINEMÁTICA DE UN ROBOT ESFÉRICO RRP
%% ========================================================================

clc; clear; close all;

%% PARÁMETROS DEL ROBOT - Longitudes
l1 = 1.5;       % Altura del poste fijo [m]
l2 = 0.75;      % Longitud del eslabón base [m]
l3_min = 0;     % Extensión prismática mínima [m]
l3_max = 0.75;  % Extensión prismática máxima [m]

%% CINEMÁTICA DIRECTA - buscamos coordenadas con los datos de las articulaciones
fprintf('========================================\n');
fprintf('       CINEMÁTICA DIRECTA (RRP)        \n');
fprintf('========================================\n');

% Ingreso y validación de q1 (Rotación en plano XY)
q1 = input('Introduzca q1 en grados (0 a 360°): ');
while (q1 < 0 || q1 > 360)
    q1 = input('VALOR INVÁLIDO. Introduzca q1 (0-360°): ');
end
q1_rad = deg2rad(q1);

% Ingreso y validación de q2 (Elevación desde abajo hacia arriba)
q2 = input('Introduzca q2 en grados (0 a 180°): ');
while (q2 < 0 || q2 > 180)
    q2 = input('VALOR INVÁLIDO. Introduzca q2 (0-180°): ');
end
q2_rad = deg2rad(q2);

% Ingreso y validación de l3 (Extensión prismática)
l3 = input('Introduzca l3 en metros (0 a 0.75): ');
while (l3 < l3_min || l3 > l3_max)
    l3 = input('VALOR INVÁLIDO. Introduzca l3 (0-0.75m): ');
end

%% CÁLCULO DE POSICIÓN DEL TCP
r_plano = (l2 + l3) * sin(q2_rad); % Proyección plano horizontal

x = r_plano * cos(q1_rad); 
y = r_plano * sin(q1_rad); 
z = l1 - (l2 + l3) * cos(q2_rad);

fprintf('\n----------------------------------------\n');
fprintf('POSICIÓN DEL TCP CALCULADA:\n');
fprintf('x = %.4f m\n', x);
fprintf('y = %.4f m\n', y);
fprintf('z = %.4f m\n', z);

%% CÁLCULO DE ORIENTACIÓN (Vector unitario n)
% El vector n apunta desde la articulación hacia el extremo
n_x = sin(q2_rad) * cos(q1_rad);
n_y = sin(q2_rad) * sin(q1_rad);
n_z = -cos(q2_rad); % Negativo para q2=0 apunte hacia abajo

fprintf('\nVECTOR DE ORIENTACIÓN:\n');
fprintf('n = [%.4f, %.4f, %.4f]\n', n_x, n_y, n_z);
fprintf('----------------------------------------\n');




%% ========================================================================
%% CINEMÁTICA INVERSA - Buscamos q1, q2 y l3 a partir de (x, y, z)
%% ========================================================================
fprintf('\n========================================\n');
fprintf('       CINEMÁTICA INVERSA (RRP)        \n');
fprintf('========================================\n');

% Ingresamos coordenadas del punto objetivo (TCP)
x1 = input('Introduzca coordenada X objetivo [m]: ');
y1 = input('Introduzca coordenada Y objetivo [m]: ');
z1 = input('Introduzca coordenada Z objetivo [m]: ');

% 1. Calculamos la distancia desde la articulación (0,0,l1) hasta el punto
% Esta distancia es la hipotenusa que debe cubrir el brazo (l2 + l3)
dist_al_punto = sqrt((x1^2 + y1^2) + (z1 - l1)^2);

% 2. Verificamos que el punto esté en el espacio de trabajo físico
% El brazo mide como mínimo l2 y como máximo (l2 + l3_max)
fprintf('\nVerificando espacio de trabajo...\n');
r_min = l2;
r_max = l2 + l3_max;

if (dist_al_punto < r_min - 0.001 || dist_al_punto > r_max + 0.001)
    error('ERROR: El punto (%.2f, %.2f, %.2f) está fuera del alcance del robot.', x1, y1, z1);
end

% 3. CÁLCULO DE VARIABLES ARTICULARES
fprintf('\n%% Calculando variables articulares...\n');

% q1: Ángulo en el plano XY
theta1 = atan2(y1, x1);
theta1_deg = rad2deg(theta1);

% q2: Ángulo de inclinación (Referencia: 0° abajo, 180° arriba)
% Usamos atan2(Radio_plano, Distancia_Z_relativa)
r_xy = sqrt(x1^2 + y1^2);
% Como 0° es abajo, el eje Z relativo es (l1 - z1)
theta2 = atan2(r_xy, l1 - z1); 
theta2_deg = rad2deg(theta2);

% l3: Extensión prismática
l3_calc = dist_al_punto - l2;

% Mostramos resultados
fprintf('Resultados obtenidos:\n');
fprintf('q1 = %.2f°\n', theta1_deg);
fprintf('q2 = %.2f°\n', theta2_deg);
fprintf('l3 = %.4f m\n', l3_calc);







%% ========================================================================
%% Vistas de los distintos planos y visualización 3D
%% ========================================================================
fprintf('\n========================================\n');
fprintf('GENERANDO SIMULACIÓN COMPLETA DEL ROBOT\n');
fprintf('========================================\n');

% Configuración de la figura
fig = figure('Name', 'Simulación RRP - Espacio de Trabajo', 'Color', 'w', 'Position', [30 30 1300 900]);

% Parámetros para el dibujo
q1_p = theta1; 
q2_p = theta2; 
l3_p = l3_calc;

% Definición de Puntos Clave
P0 = [0; 0; 0];              % Base fija
P1 = [0; 0; l1];             % Hombro (Unión q1 y q2)
r_mid = l2 * sin(q2_p);      % Radio de la parte fija del brazo
P_mid = [r_mid * cos(q1_p); r_mid * sin(q1_p); l1 - l2 * cos(q2_p)]; % Artic. Prismática
P2 = [x1; y1; z1]; % TCP (Efector final)

% Definición de Colores y Estilos
col_poste = [0.4 0.4 0.4];   % Gris
col_l2 = [0 0.45 0.74];      % Azul
col_l3 = [0.85 0.33 0.1];    % Naranja/Rojo
off = 0.15;                  % Margen para etiquetas

%% --- SUBPLOT 1: VISTA 3D CON WORKSPACE ---
subplot(2, 2, 1);
hold on; grid on; axis equal; view(135, 25);
title('Espacio de Trabajo y Configuración 3D', 'FontSize', 13);
xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');

% 1. Dibujar el Robot
plot3([P0(1) P1(1)], [P0(2) P1(2)], [P0(3) P1(3)], 'Color', col_poste, 'LineWidth', 6); 
plot3([P1(1) P_mid(1)], [P1(2) P_mid(2)], [P1(3) P_mid(3)], 'Color', col_l2, 'LineWidth', 5); 
plot3([P_mid(1) P2(1)], [P_mid(2) P2(2)], [P_mid(3) P2(3)], 'Color', col_l3, 'LineWidth', 3); 

% 2. Articulaciones (Nodos)
plot3(P0(1), P0(2), P0(3), 'ks', 'MarkerSize', 10, 'MarkerFaceColor', 'k'); 
plot3(P1(1), P1(2), P1(3), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'y');  
plot3(P_mid(1), P_mid(2), P_mid(3), 'kd', 'MarkerSize', 7, 'MarkerFaceColor', 'w'); 
plot3(P2(1), P2(2), P2(3), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g'); 

% 3. Constraints Esféricas
[xs, ys, zs] = sphere(50);
R_min = l2;
R_max = l2 + l3_max;
surf(R_max*xs, R_max*ys, l1 - R_max*zs, 'FaceAlpha', 0.07, 'EdgeColor', 'none', 'FaceColor', 'r');
surf(R_min*xs, R_min*ys, l1 - R_min*zs, 'FaceAlpha', 0.05, 'EdgeColor', 'none', 'FaceColor', 'b');

% --- Dibujar vector de orientación n con punta de flecha ---
% Calculamos las componentes unitarias
nv_x = sin(q2_p) * cos(q1_p);
nv_y = sin(q2_p) * sin(q1_p);
nv_z = -cos(q2_p);

% Graficamos la flecha saliendo del TCP (P2)
% MaxHeadSize: 0.8 asegura que la punta sea grande y visible
quiver3(P2(1), P2(2), P2(3), nv_x*0.4, nv_y*0.4, nv_z*0.4, ...
    'LineWidth', 2, 'Color', [0.5 0 0.5], 'MaxHeadSize', 0.8);
text(P2(1)+nv_x*0.4, P2(2)+nv_y*0.4, P2(3)+nv_z*0.4, ' n', ...
    'FontSize', 12, 'Interpreter', 'latex', 'Color', [0.5 0 0.5]);

text(P0(1), P0(2), P0(3)-off, ' P_0 (Base)', 'FontSize', 10, 'Interpreter', 'latex');
text(P1(1), P1(2), P1(3)+off, ' P_1 (Hombro)', 'FontSize', 10, 'Interpreter', 'latex');
text(P2(1)+off, P2(2), P2(3), ' TCP', 'Color', [0 0.5 0], 'FontSize', 11, 'Interpreter', 'latex');

axis([-2 2 -2 2 0 3]);

%% --- SUBPLOT 2: VISTA DE PLANTA (XY) ---
subplot(2, 2, 2);
hold on; grid on; axis equal;
title('Vista de Planta (Alcance Radial)');
xlabel('X [m]'); ylabel('Y [m]');

plot([0 P2(1)], [0 P2(2)], 'Color', col_l2, 'LineWidth', 3, 'Marker', 'o');
t = linspace(0, 2*pi, 100);
plot(R_min*cos(t), R_min*sin(t), 'b:', 'LineWidth', 1);
plot(R_max*cos(t), R_max*sin(t), 'r:', 'LineWidth', 1);
legend('Brazo', 'Límite Interno', 'Límite Externo', 'Location', 'northeastoutside');
axis([-1.8 1.8 -1.8 1.8]);

%% --- SUBPLOT 3: VISTA FRONTAL (XZ) ---
subplot(2, 2, 3);
hold on; grid on; axis equal;
title('Vista Frontal (Elevación XZ)');
xlabel('X [m]'); ylabel('Z [m]');

plot([P0(1) P1(1)], [P0(3) P1(3)], 'Color', col_poste, 'LineWidth', 4);
plot([P1(1) P2(1)], [P1(3) P2(3)], 'Color', col_l2, 'LineWidth', 3, 'Marker', 'o');

% Envolventes de elevación corregidas
ang = linspace(0, pi, 100);
% Límite Máximo (Rojo)
plot(R_max*sin(ang), l1 - R_max*cos(ang), 'r--', 'LineWidth', 1.2);
plot(-R_max*sin(ang), l1 - R_max*cos(ang), 'r--', 'LineWidth', 1.2);
% Límite Interno (Azul) - AGREGADO
plot(R_min*sin(ang), l1 - R_min*cos(ang), 'b:', 'LineWidth', 1);
plot(-R_min*sin(ang), l1 - R_min*cos(ang), 'b:', 'LineWidth', 1);

text(off, l1/2, ' l_1', 'FontSize', 12, 'Interpreter', 'latex');
axis([-1.8 1.8 0 3.5]);

%% --- SUBPLOT 4: VISTA LATERAL (YZ) ---
subplot(2, 2, 4);
hold on; grid on; axis equal;
title('Vista Lateral (Alcance Total YZ)');
xlabel('Y [m]'); ylabel('Z [m]');

plot([P0(2) P1(2)], [P0(3) P1(3)], 'Color', col_poste, 'LineWidth', 4);
plot([P1(2) P2(2)], [P1(3) P2(3)], 'Color', col_l2, 'LineWidth', 3, 'Marker', 'o');

% Alcance Total (Círculo completo proyectado)
plot(R_max*sin(ang), l1 - R_max*cos(ang), 'r--', 'LineWidth', 1.2); 
plot(-R_max*sin(ang), l1 - R_max*cos(ang), 'r--', 'LineWidth', 1.2);
% Límite Interno
plot(R_min*sin(ang), l1 - R_min*cos(ang), 'b:', 'LineWidth', 1);
plot(-R_min*sin(ang), l1 - R_min*cos(ang), 'b:', 'LineWidth', 1);

text(P2(2)+off, P2(3), ' TCP', 'FontSize', 11, 'Color', [0 0.5 0], 'Interpreter', 'latex');
axis([-1.8 1.8 0 3.5]);

fprintf('\nSimulación finalizada con éxito.\n');