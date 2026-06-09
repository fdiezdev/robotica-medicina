%% Ejercicio: Caseta C, mano del robot R y avion A
% Transformaciones homogeneas en 3D

close all; clear all; clc
format short g

%% Datos

theta_CR = deg2rad(45);
theta_RA = deg2rad(70);

OR_C = [40; 25; 20]        % Origen de R visto desde C
OA_R = [-350; -450; 550]   % Origen de A visto desde R

%% Matrices homogeneas

H_CR = [cos(theta_CR)  -sin(theta_CR)   0   OR_C(1);
        sin(theta_CR)   cos(theta_CR)   0   OR_C(2);
        0               0               1   OR_C(3);
        0               0               0   1];

H_RA = [cos(theta_RA)  -sin(theta_RA)   0   OA_R(1);
        sin(theta_RA)   cos(theta_RA)   0   OA_R(2);
        0               0               1   OA_R(3);
        0               0               0   1];

%% a) Caseta vista desde la mano del robot

H_RC = inv(H_CR)


%%
PC_C = [0; 0; 0; 1]

PC_R = H_RC * PC_C

%% b) Avion visto desde la caseta 
% primero mostremos la matriz que representa el avión visto desde el robot
% 
H_RA

%%
H_CA = H_CR * H_RA

%% recordando que (0,0,o,1) es el aviión en su propio sistema 
PA_A = [0; 0; 0; 1]  % multiplicamos la matriz total por ese punto 
PA_C = H_CA * PA_A    % y obtenemos el avión visto de la caseta 

%% c) Niño ubicado en la mano del robot, visto desde el avion

H_AR = inv(H_RA)

%%
PR_R = [0; 0; 0; 1]
PR_A = H_AR * PR_R

%% Resultados

disp('==============================================================')
disp('H_CR: sistema R visto desde C')
disp(H_CR)

disp('H_RA: sistema A visto desde R')
disp(H_RA)

disp('H_CA = H_CR * H_RA: sistema A visto desde C')
disp(H_CA)

disp('==============================================================')
disp('a) Caseta vista desde la mano del robot, PC_R = ')
disp(PC_R)

disp('b) Avion visto desde la caseta, PA_C = ')
disp(PA_C)

disp('c) Nino/mano del robot visto desde el avion, PR_A = ')
disp(PR_A)

%% Resultados resumidos

fprintf('\nResumen:\n')
fprintf('a) PC_R = (%.2f, %.2f, %.2f)\n', PC_R(1), PC_R(2), PC_R(3))
fprintf('b) PA_C = (%.2f, %.2f, %.2f)\n', PA_C(1), PA_C(2), PA_C(3))
fprintf('c) PR_A = (%.2f, %.2f, %.2f)\n', PR_A(1), PR_A(2), PR_A(3))

%% Dibujo simple de los sistemas

figure
hold on
grid on
axis equal
xlabel('X_C')
ylabel('Y_C')
zlabel('Z_C')
title('Sistemas C, R y A')

% Origenes vistos desde C
OC = [0; 0; 0];
OR = OR_C;
OA = PA_C(1:3);

plot3(OC(1), OC(2), OC(3), 'ko', 'MarkerFaceColor','k', 'MarkerSize',8)
plot3(OR(1), OR(2), OR(3), 'bo', 'MarkerFaceColor','b', 'MarkerSize',8)
plot3(OA(1), OA(2), OA(3), 'ro', 'MarkerFaceColor','r', 'MarkerSize',8)

text(OC(1), OC(2), OC(3), '  C')
text(OR(1), OR(2), OR(3), '  R')
text(OA(1), OA(2), OA(3), '  A')

plot3([OC(1) OR(1)], [OC(2) OR(2)], [OC(3) OR(3)], 'b--', 'LineWidth',1.5)
plot3([OR(1) OA(1)], [OR(2) OA(2)], [OR(3) OA(3)], 'r--', 'LineWidth',1.5)

% Ejes de C
dibujarSistema(eye(3), OC, 80, 'C')

% Ejes de R vistos desde C
R_CR = H_CR(1:3,1:3);
dibujarSistema(R_CR, OR, 80, 'R')

% Ejes de A vistos desde C
R_CA = H_CA(1:3,1:3);
dibujarSistema(R_CA, OA, 80, 'A')

view(35,25)
legend('C','R','A','C a R','R a A','Location','best')
hold off

%% Funcion auxiliar

function dibujarSistema(R, O, escala, nombre)
    ex = R(:,1)*escala;
    ey = R(:,2)*escala;
    ez = R(:,3)*escala;

    quiver3(O(1),O(2),O(3),ex(1),ex(2),ex(3),'LineWidth',2)
    quiver3(O(1),O(2),O(3),ey(1),ey(2),ey(3),'LineWidth',2)
    quiver3(O(1),O(2),O(3),ez(1),ez(2),ez(3),'LineWidth',2)

    text(O(1)+ex(1), O(2)+ex(2), O(3)+ex(3), [' X_' nombre])
    text(O(1)+ey(1), O(2)+ey(2), O(3)+ey(3), [' Y_' nombre])
    text(O(1)+ez(1), O(2)+ez(2), O(3)+ez(3), [' Z_' nombre])
end
