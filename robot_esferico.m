%% Definición del problema
% Robot esférico
% - Una articulación R en la base (genera ángulo p1)
% - Otra articulación R en link2(genera ángulo p2)
% - Otra articulación P en link3

clear all; close all; clc

%% Cinemática directa
% Carga de datos
l1 = 1.5    % [m]
l2 = 0.75   % [m]
%%
% valor de l3
l3 = input("\nIngrese el valor de l3 en [m]: ")
while l3 < 0 || l3 > .75
    fprintf("\nError: valor de l3 fuera de rango")
    l3 = input("\nEl valor de l3 debe estar entre (0,.75): ")
end
% valor de q1
q1 = input("Ingrese el valor de q1 en [°]: ")
while q1 < 0 || q1 > 360
    fprintf("\nError: valor de q1 fuera de rango")
    q1 = input("\nEl valor de q1 debe estar entre [0,360]: ")
end
% valor de q2
q2 = input("\nIngrese el valor de q2 en [°]: ")
while q2 < 0 || q2 > 180
    fprintf("\nError: valor de q2 fuera de rango")
    q2 = input("\nEl valor de q2 debe estar entre [0,180]: ")
end

q1_rad = deg2rad(q1)
q2_rad = deg2rad(q2)

% Calculo de TCP con cinemática directa
x = cos(q2_rad)*(l2+l3)*cos(q1_rad)
y = cos(q2_rad)*(l2+l3)*sin(q1_rad)
z = l1 + (sin(q2_rad)*(l2+l3))
% Muestro valores por consola
fprintf("\nVector TCP x cinemática directa: (%.3f [m],%.3f [m],%.3f [m])", x,y,z)

% Orientación del TCP
n_x = cos(q2_rad)*cos(q1_rad)
n_y = cos(q2_rad)*sin(q1_rad)
n_z = sin(q2_rad)

%% Cinemática inversa
X = input("\nIngrese coordenada x [m]: ")
Y = input("\nIngrese coordenada y [m]: ")
Z = input("\nIngrese coordenada z [m]: ")

% Verificamos que el punto seleccionado esté dentro del área de trabajo
val = sqrt((X^2)+(Y^2)+((Z-l1)^2)) % módulo de la distancia del punto al centro de la esfera

while val < l2 - 0.001 || val > (l2+.75) + 0.001 || Z < l1
    % Si el punto seleccionado no está dentro del área de trabajo
    fprintf("\nError: el punto seleccionado está fuera del área de trabajo del robot")
    X = input("\nIngrese coordenada x [m]: ")
    Y = input("\nIngrese coordenada y [m]: ")
    Z = input("\nIngrese coordenada z [m]: ")
    
    val = sqrt((X^2)+(Y^2)+((Z-l1)^2)) % recalculo la distancia
end

% Cuando los valores seleccionados sí están dentro
% podemos calcular los ángulos

l3_i = val-l2
q1_i = atan2(Y,X)
q1_i = rad2deg(q1_i) % paso a grados
if q1_i < 0
    q1_i = q1_i + 360;
end
q2_i = atan2((Z-l1),(sqrt((X^2)+(Y^2))))
q2_i = rad2deg(q2_i) % paso a grados

% Muestro valores por consola
fprintf("\nÁngulos para lograr TCP x cinemática inversa: (q1 = %.3f °,q2 = %.3f °)", q1_i,q2_i)
fprintf("\nValor de l3 para cinemática inversa: %.3f [m]", l3_i)

%% Visualización 3D diferenciando l2 y l3

O  = [0 0 0];      % base
A  = [0 0 l1];     % articulación R2

% Dirección radial del brazo
ux = cos(q2_rad)*cos(q1_rad);
uy = cos(q2_rad)*sin(q1_rad);
uz = sin(q2_rad);

% Punto final de l2
B = A + l2*[ux uy uz];

% Punto final de l3, TCP
TCP = A + (l2+l3)*[ux uy uz];

figure
hold on
grid on
axis equal
view(45,30)

xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')
title('Robot esférico RRP - l2 y l3 diferenciados')

% Link vertical l1
plot3([O(1) A(1)], [O(2) A(2)], [O(3) A(3)], ...
      'k', 'LineWidth', 4)

% Link l2
plot3([A(1) B(1)], [A(2) B(2)], [A(3) B(3)], ...
      'b', 'LineWidth', 4)

% Link prismático l3
plot3([B(1) TCP(1)], [B(2) TCP(2)], [B(3) TCP(3)], ...
      'r', 'LineWidth', 4)

% Puntos
plot3(O(1), O(2), O(3), 'ko', 'MarkerSize', 8, 'MarkerFaceColor','k')
plot3(A(1), A(2), A(3), 'ro', 'MarkerSize', 8, 'MarkerFaceColor','r')
plot3(B(1), B(2), B(3), 'bo', 'MarkerSize', 8, 'MarkerFaceColor','b')
plot3(TCP(1), TCP(2), TCP(3), 'go', 'MarkerSize', 8, 'MarkerFaceColor','g')

% Etiquetas
text(O(1), O(2), O(3), '  Base')
text(A(1), A(2), A(3), '  R2')
text(B(1), B(2), B(3), '  Fin de l2')
text(TCP(1), TCP(2), TCP(3), '  TCP')

% Vector orientación del TCP
escala = 0.3;
quiver3(TCP(1), TCP(2), TCP(3), ...
        escala*ux, escala*uy, escala*uz, ...
        'm', 'LineWidth', 2)

text(TCP(1)+escala*ux, TCP(2)+escala*uy, TCP(3)+escala*uz, ...
     '  Orientación TCP')

% Área de trabajo: esfera interna y externa
[sx, sy, sz] = sphere(40);

r_min = l2;
r_max = l2 + 0.75;

% Esfera externa: alcance máximo
surf(r_max*sx, r_max*sy, l1 + r_max*sz, ...
     'FaceAlpha',0.06, 'EdgeAlpha',0.08)

% Esfera interna: límite mínimo
surf(r_min*sx, r_min*sy, l1 + r_min*sz, ...
     'FaceAlpha',0.08, 'EdgeAlpha',0.08)

% Límites
lim = l1 + l2 + 0.75;
xlim([-lim lim])
ylim([-lim lim])
zlim([0 lim + 0.5])

legend('l1','l2','l3','Base','R2','Fin l2','TCP','Orientación','Área de trabajo')