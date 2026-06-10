%% CINEMÁTICA INVERSA ROBOT 2 GDL (SCRIPT)
% - Robot planar de 2 GDL
% - Unidades en GRADOS (acosd, atan2d, sind, cosd)
% - Al final dibuja el robot en las dos posiciones posibles

close all; clear all; clc;
format bank   % números con pocos decimales

%% Constantes
l1 = 0.70;
l2 = 0.30;

%% Punto objetivo (x,y) en el plano
% Cambiá este valor para probar:
p = [0.20; 0.9];   % <-- editar
x = p(1);
y = p(2);

%% Cálculo de la Cinemática Inversa
argCos = (x^2 + y^2 - l1^2 - l2^2) / (2 * l1 * l2);

if abs(argCos) > 1
    argCos = sign(argCos);
    disp('Cuidado! Argumento del coseno > 1');
end

% Dos posibles soluciones para q2
q2(1) = -acosd(argCos);
q2(2) =  acosd(argCos);

% Dos posibles soluciones para q1
q1(1) = atan2d(y, x) - atan2d(l2 * sind(q2(1)), (l1 + l2 * cosd(q2(1))));
q1(2) = atan2d(y, x) - atan2d(l2 * sind(q2(2)), (l1 + l2 * cosd(q2(2))));

% Matriz de soluciones
q = [q1' q2']

%% Mostrar resultados
disp('Soluciones [q1  q2] en grados (fila = solución):');
disp(q);

%% =========================================================
%% DIBUJO DEL ROBOT EN LAS DOS POSICIONES POSIBLES
%% =========================================================

figure;
hold on;
grid on;
axis equal;

title('Robot de 2 GDL - Dos soluciones de cinemática inversa');
xlabel('Eje X');
ylabel('Eje Y');

% Dibujar el punto objetivo
plot(x, y, 'ko', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'y');
text(x, y, '  Punto objetivo', 'FontSize', 10);

% Colores para cada solución
col1 = 'b';
col2 = 'r';

for i = 1:2
    
    % Ángulos de la solución i
    theta1 = q1(i);
    theta2 = q2(i);
    
    % Posición de la articulación 1 (extremo del primer eslabón)
    x1 = l1 * cosd(theta1);
    y1 = l1 * sind(theta1);
    
    % Posición del efector final
    x2 = x1 + l2 * cosd(theta1 + theta2);
    y2 = y1 + l2 * sind(theta1 + theta2);
    
    if i == 1
        colorActual = col1;
        nombreSol = 'Solución 1';
    else
        colorActual = col2;
        nombreSol = 'Solución 2';
    end
    
    % Dibujar eslabón 1
    plot([0 x1], [0 y1], [colorActual '-o'], ...
        'LineWidth', 3, 'MarkerSize', 7, 'MarkerFaceColor', colorActual);
    
    % Dibujar eslabón 2
    plot([x1 x2], [y1 y2], [colorActual '-o'], ...
        'LineWidth', 3, 'MarkerSize', 7, 'MarkerFaceColor', colorActual);
    
    % Etiquetar codo y TCP
    text(x1, y1, ['  Codo ' num2str(i)], 'Color', colorActual, 'FontSize', 10);
    text(x2, y2, ['  TCP ' num2str(i)], 'Color', colorActual, 'FontSize', 10);
    
    % Mostrar ángulos en consola
    fprintf('\n%s:\n', nombreSol);
    fprintf('q1 = %.2f grados\n', theta1);
    fprintf('q2 = %.2f grados\n', theta2);
    fprintf('TCP calculado = (%.4f, %.4f)\n', x2, y2);
end

% Dibujar la base
plot(0, 0, 'ks', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
text(0, 0, '  Base', 'FontSize', 10);

legend('Punto objetivo', 'Solución 1', '', 'Solución 2', '', 'Location', 'best');

hold off;