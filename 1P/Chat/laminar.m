%% Limpio entorno
clear all;
close all;
clc;

%% Definición del problema
% Modelo espacial de 2 rotaciones
% OJO: esto no es un robot laminar R-R clásico.
% El TCP se mueve sobre una superficie esférica de radio L1
% centrada en (0,0,L).

L = 2;    % Altura/desplazamiento fijo [m]
L1 = 2;   % Longitud del eslabón móvil [m]

%% Ingreso de ángulos

theta1 = input("Ingrese el valor de theta1 en grados [0,180]: ");
theta2 = input("Ingrese el valor de theta2 en grados [0,180]: ");

% Validación de rangos
if theta1 < 0 || theta1 > 180
    error("theta1 debe estar entre 0° y 180°");
end

if theta2 < 0 || theta2 > 180
    error("theta2 debe estar entre 0° y 180°");
end

% Paso a radianes
theta1_rad = deg2rad(theta1);
theta2_rad = deg2rad(theta2);

%% Cinemática directa

X = L1 * sin(theta1_rad) * cos(theta2_rad);
Y = L1 * sin(theta1_rad) * sin(theta2_rad);
Z = L - L1 * cos(theta1_rad);

fprintf("\nCinemática directa:");
fprintf("\nTCP = (%.3f, %.3f, %.3f) [m]\n", X, Y, Z);

%% Cinemática inversa

x = input("\nIngrese coordenada X [m]: ");
y = input("Ingrese coordenada Y [m]: ");
z = input("Ingrese coordenada Z [m]: ");

tol = 1e-6;

% Distancia al centro de la esfera
check = x^2 + y^2 + (z - L)^2;

% Como L1 es fijo, el punto debe estar sobre la superficie esférica
if abs(check - L1^2) > tol
    error("El punto no pertenece a la superficie alcanzable del robot.");
end

% Restricción de theta2 entre 0° y 180°
% Eso implica que y debe ser mayor o igual a cero.
if y < -tol
    error("El punto está fuera del rango angular de theta2. Para theta2 entre 0° y 180°, debe cumplirse y >= 0.");
end

rho = sqrt(x^2 + y^2);

% Cálculo de theta1
theta1_inv = atan2d(rho, L - z);

% Cálculo de theta2
% Si rho = 0, el punto está en un polo y theta2 queda indeterminado.
if rho < tol
    theta2_inv = NaN;
    fprintf("\nEl punto está sobre el eje Z. theta2 es indeterminado.\n");
else
    theta2_inv = atan2d(y, x);

    if theta2_inv < 0
        theta2_inv = theta2_inv + 360;
    end

    if theta2_inv > 180 + tol
        error("El punto requiere un theta2 fuera del rango [0°,180°].");
    end
end

fprintf("\nCinemática inversa:");
fprintf("\ntheta1 = %.3f°", theta1_inv);

if isnan(theta2_inv)
    fprintf("\ntheta2 = indeterminado\n");
else
    fprintf("\ntheta2 = %.3f°\n", theta2_inv);
end

%% Gráfico del área de trabajo en 3D

n = 100;

[t1, t2] = meshgrid(linspace(0, pi, n), linspace(0, pi, n));

Xw = L1 .* sin(t1) .* cos(t2);
Yw = L1 .* sin(t1) .* sin(t2);
Zw = L - L1 .* cos(t1);

figure;
surf(Xw, Yw, Zw, ...
    'FaceAlpha', 0.45, ...
    'EdgeAlpha', 0.15);

hold on;
plot3(X, Y, Z, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

xlabel('X [m]');
ylabel('Y [m]');
zlabel('Z [m]');
title('Área de trabajo 3D');
grid on;
axis equal;
view(45, 25);

%% Vista del área de trabajo desde el plano XY

phi = linspace(0, pi, 300);

x_xy = L1 * cos(phi);
y_xy = L1 * sin(phi);

figure;
fill([x_xy, L1], [y_xy, 0], [0.8 0.9 1], ...
    'FaceAlpha', 0.5, ...
    'EdgeColor', 'b');

hold on;
plot(X, Y, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

xlabel('X [m]');
ylabel('Y [m]');
title('Proyección del área de trabajo en el plano XY');
grid on;
axis equal;

xlim([-L1-0.5, L1+0.5]);
ylim([-0.5, L1+0.5]);

%% Vista del área de trabajo desde el plano XZ

phi = linspace(0, 2*pi, 300);

x_xz = L1 * cos(phi);
z_xz = L + L1 * sin(phi);

figure;
fill(x_xz, z_xz, [0.8 0.9 1], ...
    'FaceAlpha', 0.5, ...
    'EdgeColor', 'b');

hold on;
plot(X, Z, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

xlabel('X [m]');
ylabel('Z [m]');
title('Proyección del área de trabajo en el plano XZ');
grid on;
axis equal;

xlim([-L1-0.5, L1+0.5]);
ylim([L-L1-0.5, L+L1+0.5]);