%% Cinemática inversa de un robot plano R-P
% Robot de 2 grados de libertad:
%   1) theta = articulación rotacional
%   2) d     = articulación prismática
%
% Parámetros:
%   - Barra azul fija: L1 = 2 m
%   - Barra prismática roja: 0 <= d <= 1.5 m
%
% Entrada:
%   - Posición deseada del TCP: (x, y)
%
% Salida:
%   - theta [rad y grados]
%   - d [m]

clc;
clear;
close all;

%% Parámetros del robot
L1 = 2.0      % Longitud fija de la barra azul [m]
d_max = 1.5   % Extensión máxima [m]
d_min = 0.0   % Extensión mínima [m]

%% Posición deseada del TCP (ejemplo)
x = 2.5981    % [m]
y = 1.5    % [m]

%% Cinemática inversa

% 1) Distancia desde el origen hasta el TCP
r = sqrt(x^2 + y^2)

% 2) Ángulo de la articulación rotacional
theta_rad = atan2(y, x)   % [rad]
theta_deg = rad2deg(theta_rad)
% 3) Desplazamiento prismático
d = r - L1          % [m]

%% Verificación de factibilidad
if d < d_min || d > d_max
    fprintf('Punto NO alcanzable.\n');
    fprintf('La extensión calculada es d = %.4f m\n', d);
    fprintf('Debe cumplirse: %.2f <= d <= %.2f m\n', d_min, d_max);
else
    fprintf('Punto alcanzable.\n');
    fprintf('--- CINEMATICA INVERSA DEL ROBOT R-P ---\n');
    fprintf('Posicion deseada del TCP:\n');
    fprintf('x = %.4f m\n', x);
    fprintf('y = %.4f m\n', y);
    fprintf('\nResultados:\n');
    fprintf('theta = %.4f rad\n', theta_rad);
    fprintf('theta = %.2f grados\n', rad2deg(theta_rad));
    fprintf('d = %.4f m\n', d);
end

%% Dibujo del robot para verificar la solución
if d >= d_min && d <= d_max

    % Base
    x0 = 0;
    y0 = 0;

    % Fin de la barra azul
    x1 = L1 * cos(theta_rad);
    y1 = L1 * sin(theta_rad);

    % TCP
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

    % Dibujar puntos importantes
    plot(x0, y0, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % base
    plot(x1, y1, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % unión
    plot(x2, y2, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g'); % TCP

    % Marcar el punto deseado
    plot(x, y, 'mx', 'MarkerSize', 12, 'LineWidth', 2);

    % Etiquetas
    text(x0, y0, '  Base', 'FontSize', 10);
    text(x1, y1, '  Articulacion 2', 'FontSize', 10);
    text(x2, y2, '  TCP', 'FontSize', 10);

    xlabel('X [m]');
    ylabel('Y [m]');
    title('Robot plano R-P - Cinematica Inversa');

    legend('Barra azul (L1)', 'Barra roja (d)', 'Base/Union', 'TCP', 'Punto deseado', ...
        'Location', 'best');

    hold off;
end
