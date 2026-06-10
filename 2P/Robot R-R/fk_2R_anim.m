%% ===============================================================
% FK 2R - Animación entre estado inicial y final
% ---------------------------------------------------------------
% Mantiene nombres del script anterior:
%   - l1, l2: longitudes [m]
%   - q1, q2: ángulos articulares (RAD) que se van actualizando
%   - x, y  : posición de la punta (end-effector) en el plano XY
%
% ¿Qué hace?
%  - Define (hardcoded) un estado INICIAL (q1_i, q2_i) y uno FINAL (q1_f, q2_f)
%  - Interpola los ángulos y anima el movimiento en pantalla
%  - Muestra trayectoria de la punta
% ===============================================================

close all; clear; clc;
format bank   % 2 decimales en la Command Window

%% ---------- Parámetros geométricos ----------
l1 = 0.70       % [m]
l2 = 0.30       % [m]

%% ---------- ESTADO INICIAL (hardcoded) ----------
% (Podés cambiar estos valores)
q1_i = deg2rad(0);    % rad
q2_i = deg2rad(0);   % rad

%% ---------- ESTADO FINAL (hardcoded) ----------
% (Podés cambiar estos valores)
q1_f = deg2rad(360);    % rad
q2_f = deg2rad(360);    % rad

%% ---------- Parámetros de animación ----------
Nsteps   = 60;         % cantidad de pasos de la animación
t_total  = 2.0;        % duración aprox. [s]
dt       = t_total / Nsteps;

%% ---------- Prealocar para registrar trayectoria ----------
traj = zeros(2, Nsteps+1);   % [x; y] de la punta

%% ---------- Figura y ejes ----------
figure('Name','FK 2R - Animación');
axis equal; grid on; hold on;
xlabel('X [m]'); ylabel('Y [m]');

% Límite de vista (radio máximo del brazo) + margen
R = l1 + l2;  m = 0.1;
xlim([-R-m, R+m]); ylim([-R-m, R+m]);

% Origen destacado
scatter(0,0,60,[1 0 1],'filled','Marker','p','DisplayName','Origen (0,0)');
legend('Location','best');

title('Brazo 2R - Animación de (q1_i,q2_i) ? (q1_f,q2_f)');

%% ---------- Dibujo inicial ----------
% Interpolar paso 0 = estado inicial
q1 = q1_i; 
q2 = q2_i;

% Cinemática directa del estado inicial
[x, y, P1, P2] = fk2R_xy(l1, l2, q1, q2);

% Guardar primer punto de trayectoria
traj(:,1) = [x; y];

% Dibujos (handles) para actualizar sin recrear gráficos
h_links = plot([0 P1(1) P2(1)], [0 P1(2) P2(2)], '-o', ...
    'LineWidth', 2, 'MarkerFaceColor', [0.9 0.4 0.1], 'MarkerSize', 7, ...
    'Color', [0 0.45 0.74]);     % celeste como antes
h_codo  = scatter(P1(1), P1(2), 45, [0.2 0.6 0.2], 'filled', 'MarkerEdgeColor','k'); % codo
h_tip   = scatter(x, y, 45, [0.85 0.33 0.1], 'filled', 'MarkerEdgeColor','k');       % punta
h_traj  = plot(traj(1,1), traj(2,1), '-', 'LineWidth', 1.5, 'Color', [0.8 0 0]);     % trayectoria

% Etiquetas
txt_codo = text(P1(1), P1(2), '  Codo', 'Color',[0.2 0.6 0.2]);
txt_tip  = text(x, y, '  Punta', 'Color',[0.85 0.33 0.1]);

%% ---------- Animación ----------
for k = 1:Nsteps
    % Interpolación lineal de ángulos (en rad)
    alpha = k / Nsteps;
    q1 = (1 - alpha)*q1_i + alpha*q1_f;
    q2 = (1 - alpha)*q2_i + alpha*q2_f;

    % FK en este frame
    [x, y, P1, P2] = fk2R_xy(l1, l2, q1, q2);

    % Actualizar trayectoria
    traj(:,k+1) = [x; y];

    % ---- Actualizar gráficos (más eficiente que redibujar) ----
    set(h_links, 'XData', [0 P1(1) P2(1)], 'YData', [0 P1(2) P2(2)]);
    set(h_codo,  'XData', P1(1), 'YData', P1(2));
    set(h_tip,   'XData', x,     'YData', y);
    set(h_traj,  'XData', traj(1,1:k+1), 'YData', traj(2,1:k+1));

    set(txt_codo, 'Position', [P1(1) P1(2) 0]);
    set(txt_tip,  'Position', [x y 0]);

    % Info en la barra de título
    title(sprintf('Brazo 2R - q1=%.1f°  q2=%.1f°', rad2deg(q1), rad2deg(q2)));

    drawnow;
    pause(dt);
end

%% ---------- Reporte final ----------
fprintf('--- Estados ---\n');
fprintf('Inicial: q1 = %.2f°  q2 = %.2f°\n', rad2deg(q1_i), rad2deg(q2_i));
fprintf('Final:   q1 = %.2f°  q2 = %.2f°\n', rad2deg(q1_f), rad2deg(q2_f));
fprintf('Punta final: x = %.2f m, y = %.2f m\n', x, y);

%% ===============================================================
% ================== FUNCIONES AUXILIARES ========================
% ===============================================================

function [x, y, P1, P2] = fk2R_xy(l1, l2, q1, q2)
% FK del 2R planar. Devuelve:
%   - x,y  : posición de la punta
%   - P1   : posición del codo [x1;y1]
%   - P2   : posición de la punta [x2;y2]
x1 = l1*cos(q1);       y1 = l1*sin(q1);
x  = x1 + l2*cos(q1+q2);
y  = y1 + l2*sin(q1+q2);
P1 = [x1; y1];
P2 = [x;  y ];
end