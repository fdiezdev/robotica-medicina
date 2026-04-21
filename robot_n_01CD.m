%% Cinemática directa de un robot plano R-P
% Robot de 2 grados de libertad:
%   1) theta = articulación rotacional
%   2) d     = articulación prismática
%
% Datos del robot:
%   - Barra azul fija: L1 = 2 m
%   - Barra roja prismática: d entre 0 y 1.5 m
%   - El TCP está al final de la barra prismática
%
% Suposición:
%   La barra roja se extiende en la misma dirección que la barra azul.

clc;
clear;
close all;

%% Parámetros del robot
L1 = 2.0     % Longitud fija de la barra azul [m]
d_max = 1.5   % Extensión máxima de la barra prismática [m]

%% Variables articulares de ejemplo
theta_deg = 45         % Ángulo en grados
theta = deg2rad(theta_deg) % Conversión a radianes
d = 1.3                % Extensión prismática [m]

%% Verificación de límites
if d < 0 || d > d_max
    error('El valor de d debe estar entre 0 y %.2f metros.', d_max);
end

%% Cinemática directa
% La distancia total desde el origen al TCP es:
r = L1 + d

% Coordenadas del TCP en el plano
x = r * cos(theta)
y = r * sin(theta)

%% Mostrar resultados
fprintf('--- CINEMATICA DIRECTA DEL ROBOT R-P ---\n');
fprintf('Theta = %.2f grados\n', theta_deg);
fprintf('d = %.2f m\n', d);
fprintf('Posicion del TCP:\n');
fprintf('x = %.4f m\n', x);
fprintf('y = %.4f m\n', y);

%% Dibujo del robot
% Base en el origen
x0 = 0;
y0 = 0;

% Fin de la barra azul
x1 = L1 * cos(theta);
y1 = L1 * sin(theta);

% TCP (fin de la barra roja)
x2 = x;
y2 = y;

figure;
hold on;
grid on;
axis equal;

% Dibujar barra azul
plot([x0 x1], [y0 y1], 'b', 'LineWidth', 4);

% Dibujar barra roja
plot([x1 x2], [y1 y2], 'r', 'LineWidth', 4);

% Dibujar articulaciones y TCP
plot(x0, y0, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % base
plot(x1, y1, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % unión
plot(x2, y2, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g'); % TCP

% Etiquetas
text(x0, y0, '  Base', 'FontSize', 10);
text(x1, y1, '  Articulacion 2', 'FontSize', 10);
text(x2, y2, '  TCP', 'FontSize', 10);

xlabel('X [m]');
ylabel('Y [m]');
title('Robot plano R-P - Cinematica Directa');

legend('Barra azul (L1)', 'Barra roja (d)', 'Location', 'best');
hold off;