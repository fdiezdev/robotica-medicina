%% EJERCITACIÓN PARA EL SEGUNDO  PARCIAL 

%  Ejercicio 3 - Dron y estación de control
%  Composición e inversa de una matriz homogénea
% ===============================================================

close all; clear; clc;

%% Matriz homogénea H
% H transforma coordenadas desde la estación E al sistema del dron D.
% La estación está girada 180 grados alrededor de Z
% y trasladada a p = (30, 100, -20), vista desde el dron.

H = [-1   0   0   30;
      0  -1   0  100;
      0   0   1  -20;
      0   0   0    1];

disp('Matriz H: transforma de estación E a dron D');
disp(H);

%% Punto P expresado en el sistema de la estación
% Técnico ubicado junto a la estación

PE = [2; -3; 0; 1];

%% Calcular el punto visto desde el sistema del dron
PD = H * PE;

disp('Punto PE expresado en el sistema de la estación:');
disp(PE);

disp('Punto PD expresado en el sistema del dron:');
disp(PD);

%% Calcular la matriz inversa
% Hi transforma desde el sistema del dron al sistema de la estación

Hi = inv(H);

disp('Matriz inversa Hi = inv(H): transforma de dron D a estación E');
disp(Hi);

%% Verificar que Hi * H da la matriz identidad
I = Hi * H;

disp('Verificación Hi * H:');
disp(I);

%% Nuevo punto Q expresado en el sistema del dron
% El dron detecta un objeto en su propio sistema

QD = [25; 110; -15; 1]

%% Calcular el punto visto desde la estación
QE = Hi * QD;

disp('Punto QD expresado en el sistema del dron:');
disp(QD);

disp('Punto QE expresado en el sistema de la estación:');
disp(QE);

%% fin ejercicio 









%% ===============================================================
%  Ejercicio - Robot y avión respecto a la caseta
%  Sistemas:
%  C = caseta
%  R = mano del robot / niño
%  A = avión
%
%  Objetivo didáctico:
%  Ver la composición entre los tres sistemas:
%
%      A  --->  R  --->  C
%
%  H_RA transforma de A hacia R
%  H_CR transforma de R hacia C
%  H_CA = H_CR * H_RA transforma de A hacia C
% ===============================================================

close all; clear; clc;

%% ===============================================================
%  Datos del problema
% ===============================================================

% Origen del sistema R respecto del sistema C
% Mano del robot vista desde la caseta
OR_C = [40; 25; 20; 1];

% Origen del sistema A respecto del sistema C
% Avión visto desde la caseta
OA_C = [-350; -450; 550; 1];

% Ángulos de rotación
theta_CR = deg2rad(45);   % R rotado +45° alrededor de Z respecto de C
theta_RA = deg2rad(70);   % A rotado +70° alrededor de Z respecto de R

%% ===============================================================
%  Paso 1: construir H_CR
%  H_CR transforma puntos desde R hacia C
% ===============================================================

Rot_CR = [cos(theta_CR)  -sin(theta_CR)   0   0;
          sin(theta_CR)   cos(theta_CR)   0   0;
          0               0               1   0;
          0               0               0   1];

Tras_CR = [1   0   0   OR_C(1);
           0   1   0   OR_C(2);
           0   0   1   OR_C(3);
           0   0   0   1];

H_CR = Tras_CR * Rot_CR;

%% ===============================================================
%  Paso 2: expresar el origen del avión A en el sistema R
% ===============================================================

% El avión está dado en el sistema C como OA_C.
% Para verlo desde R usamos la inversa de H_CR.
OA_R = inv(H_CR) * OA_C;

%% ===============================================================
%  Paso 3: construir H_RA
%  H_RA transforma puntos desde A hacia R
% ===============================================================

Rot_RA = [cos(theta_RA)  -sin(theta_RA)   0   0;
          sin(theta_RA)   cos(theta_RA)   0   0;
          0               0               1   0;
          0               0               0   1];

Tras_RA = [1   0   0   OA_R(1);
           0   1   0   OA_R(2);
           0   0   1   OA_R(3);
           0   0   0   1];

H_RA = Tras_RA * Rot_RA;

%% ===============================================================
%  Paso 4: componer la transformación total H_CA
%  H_CA transforma puntos desde A hacia C
%
%  Como:
%       A ---> R se hace con H_RA
%       R ---> C se hace con H_CR
%
%  Entonces:
%       A ---> C se hace con H_CA = H_CR * H_RA
% ===============================================================

H_CA = H_CR * H_RA;

%% ===============================================================
%  Mostrar matrices principales
% ===============================================================

disp('===============================================================');
disp('PASO 1: Sistema R respecto de C');
disp('===============================================================');

disp('Rot_CR: rotación de R respecto de C');
disp(Rot_CR);

disp('Tras_CR: traslación de R respecto de C');
disp(Tras_CR);

disp('H_CR = Tras_CR * Rot_CR');
disp(H_CR);

disp('===============================================================');
disp('PASO 2: Origen del avión A visto desde R');
disp('===============================================================');

disp('OA_C: origen del avión visto desde C');
disp(OA_C);

disp('OA_R = inv(H_CR) * OA_C');
disp(OA_R);

disp('===============================================================');
disp('PASO 3: Sistema A respecto de R');
disp('===============================================================');

disp('Rot_RA: rotación de A respecto de R');
disp(Rot_RA);

disp('Tras_RA: traslación de A respecto de R');
disp(Tras_RA);

disp('H_RA = Tras_RA * Rot_RA');
disp(H_RA);

disp('===============================================================');
disp('PASO 4: Composición total A -> R -> C');
disp('===============================================================');

disp('H_CA = H_CR * H_RA');
disp(H_CA);

disp('Verificación: el origen de A transformado hacia C debe dar OA_C');
OA_C_verificado = H_CA * [0; 0; 0; 1];
disp(OA_C_verificado);

%% ===============================================================
%  Pregunta a)
%  ¿Cuál es la distancia (X,Y,Z) a la caseta vista desde la mano del robot?
% ===============================================================

OC_C = [0; 0; 0; 1];

% Para ver la caseta desde R:
OC_R = inv(H_CR) * OC_C;

disp('===============================================================');
disp('Pregunta a)');
disp('Caseta vista desde la mano del robot, sistema R');
disp('===============================================================');

fprintf('X_R = %.3f\n', OC_R(1));
fprintf('Y_R = %.3f\n', OC_R(2));
fprintf('Z_R = %.3f\n\n', OC_R(3));

%% ===============================================================
%  Pregunta b)
%  ¿Cuál es la distancia del avión en los ejes (X,Y,Z) respecto de la caseta?
% ===============================================================

disp('===============================================================');
disp('Pregunta b)');
disp('Avión visto desde la caseta, sistema C');
disp('===============================================================');

fprintf('X_C = %.3f\n', OA_C(1));
fprintf('Y_C = %.3f\n', OA_C(2));
fprintf('Z_C = %.3f\n\n', OA_C(3));

%% ===============================================================
%  Pregunta c)
%  ¿Qué distancia (X,Y,Z) separa al niño, ubicado en la mano del robot,
%  del avión, cuando se observa desde el sistema del avión?
% ===============================================================

% El niño está en el origen del sistema R
Pninio_R = [0; 0; 0; 1];

% Como H_RA transforma de A hacia R,
% para ver un punto de R desde A usamos inv(H_RA).
Pninio_A = inv(H_RA) * Pninio_R;

disp('===============================================================');
disp('Pregunta c)');
disp('Niño en la mano del robot visto desde el sistema A del avión');
disp('===============================================================');

fprintf('X_A = %.3f\n', Pninio_A(1));
fprintf('Y_A = %.3f\n', Pninio_A(2));
fprintf('Z_A = %.3f\n\n', Pninio_A(3));

%% ===============================================================
%  Verificaciones adicionales
% ===============================================================

disp('===============================================================');
disp('Verificaciones');
disp('===============================================================');

disp('inv(H_CR) * H_CR');
disp(inv(H_CR) * H_CR);

disp('inv(H_RA) * H_RA');
disp(inv(H_RA) * H_RA);

disp('inv(H_CA) * H_CA');
disp(inv(H_CA) * H_CA);

%% ===============================================================
%  Dibujo simple en el sistema C
% ===============================================================

figure('Color','white');
hold on; grid on; axis equal;

xlabel('X_C');
ylabel('Y_C');
zlabel('Z_C');
title('Caseta, mano del robot y avión - Sistemas C, R y A');

% Puntos principales expresados en C
OC = OC_C(1:3);
OR = OR_C(1:3);
OA = OA_C(1:3);

% Caseta
plot3(OC(1), OC(2), OC(3), 'ks', ...
    'MarkerSize', 10, 'MarkerFaceColor', 'k');
text(OC(1), OC(2), OC(3), '  Caseta - Sistema C');

% Mano del robot / niño
plot3(OR(1), OR(2), OR(3), 'ro', ...
    'MarkerSize', 10, 'MarkerFaceColor', 'r');
text(OR(1), OR(2), OR(3), '  Mano robot / Niño - Sistema R');

% Avión
plot3(OA(1), OA(2), OA(3), 'bo', ...
    'MarkerSize', 10, 'MarkerFaceColor', 'b');
text(OA(1), OA(2), OA(3), '  Avión - Sistema A');

% Líneas de referencia
plot3([OC(1) OR(1)], [OC(2) OR(2)], [OC(3) OR(3)], 'r--');
plot3([OR(1) OA(1)], [OR(2) OA(2)], [OR(3) OA(3)], 'm--');
plot3([OC(1) OA(1)], [OC(2) OA(2)], [OC(3) OA(3)], 'b--');

legend('Caseta C', 'Mano robot / Niño R', 'Avión A', ...
       'C-R', 'R-A', 'C-A');

view(45,30);

%% ===============================================================
%  Interpretación final
% ===============================================================

disp('===============================================================');
disp('Interpretación didáctica');
disp('===============================================================');
disp('H_CR transforma puntos desde la mano del robot R hacia la caseta C.');
disp('H_RA transforma puntos desde el avión A hacia la mano del robot R.');
disp('H_CA = H_CR * H_RA transforma puntos desde el avión A hacia la caseta C.');
disp('La pregunta c usa inv(H_RA), porque queremos ver la mano del robot desde el avión.');



