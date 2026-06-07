%% ================================================================
% MATRIZ JACOBIANA A PARTIR DE DENAVIT-HARTENBERG
% Robot planar 2R: dos articulaciones Rotativas
%
% Este programa acompania el apunte de clase:
% 1) Construye las matrices D-H A01 y A12.
% 2) Obtiene la matriz homogenea total T = A01*A12.
% 3) Extrae posicion y orientacion del efector final.
% 4) Calcula la matriz jacobiana lineal Jv.
% 5) Calcula tambien la jacobiana angular Jw y la jacobiana completa J.
% 6) Evalua un ejemplo numerico.
% 7) Calcula las velocidades finales vx, vy, vz.
% 8) Dibuja el robot y las velocidades producidas por cada articulacion.
% ================================================================

close all; clear all; clc
format bank

%% ================================================================
% 1. VARIABLES SIMBOLICAS
% ================================================================

syms q1 q2 l1 l2 real

%% ================================================================
% 2. PARAMETROS DE DENAVIT-HARTENBERG
% ================================================================
% Robot planar 2R:
%
% i       theta_i       d_i       a_i       alpha_i
% -------------------------------------------------
% 1       q1            0         l1        0
% 2       q2            0         l2        0
%
% q1, q2: variables rotativas
% l1, l2: longitudes de los eslabones

q    = [q1   q2]
d    = [0    0]
a    = [l1   l2]
alfa = [0    0]

%% ================================================================
% 3. MATRIZ A01
% ================================================================

i = 1;

A01 = [cos(q(i))  -cos(alfa(i))*sin(q(i))   sin(alfa(i))*sin(q(i))   a(i)*cos(q(i)); ...
       sin(q(i))   cos(alfa(i))*cos(q(i))  -sin(alfa(i))*cos(q(i))   a(i)*sin(q(i)); ...
       0           sin(alfa(i))             cos(alfa(i))              d(i); ...
       0           0                        0                         1];

A01 = simplify(A01,'Steps',100);

disp('==============================================================')
disp('A01 simbolica = ')
disp(A01)

%% ================================================================
% 4. MATRIZ A12
% ================================================================

i = 2;

A12 = [cos(q(i))  -cos(alfa(i))*sin(q(i))   sin(alfa(i))*sin(q(i))   a(i)*cos(q(i)); ...
       sin(q(i))   cos(alfa(i))*cos(q(i))  -sin(alfa(i))*cos(q(i))   a(i)*sin(q(i)); ...
       0           sin(alfa(i))             cos(alfa(i))              d(i); ...
       0           0                        0                         1];

A12 = simplify(A12,'Steps',100);

disp('==============================================================')
disp('A12 simbolica = ')
disp(A12)

%% ================================================================
% 5. MATRIZ HOMOGENEA TOTAL
% ================================================================
% T representa la pose del efector final respecto de la base.
% T no multiplica al vector [q1; q2].
% T depende de q1 y q2, y multiplica puntos homogeneos.

T = simplify(A01*A12,'Steps',100);

disp('==============================================================')
disp('T simbolica = A01*A12 = ')
disp(T)

disp('T en formato pretty = ')
pretty(T)

%% ================================================================
% 6. POSICION Y ORIENTACION DEL EFECTOR FINAL
% ================================================================
% R   = orientacion del efector final respecto de la base
% pos = posicion del efector final respecto de la base

R   = simplify(T(1:3,1:3),'Steps',100);
pos = simplify(T(1:3,4),'Steps',100);

x = simplify(pos(1),'Steps',100);
y = simplify(pos(2),'Steps',100);
z = simplify(pos(3),'Steps',100);

disp('==============================================================')
disp('Orientacion simbolica del efector final R = ')
disp(R)

disp('Posicion simbolica del efector final pos = ')
disp(pos)

%% ================================================================
% 7. OTRA FORMA DE OBTENER LA POSICION DEL EFECTOR
% ================================================================
% El origen del efector final, expresado en su propio sistema, es:
% [0; 0; 0; 1].
% Al multiplicar T por ese punto, se obtiene ese origen visto desde
% la base del robot.

p_efector_local = [0; 0; 0; 1];
p_efector_base  = simplify(T*p_efector_local,'Steps',100);

disp('==============================================================')
disp('Origen del efector final visto desde la base = ')
disp(p_efector_base)

%% ================================================================
% 8. MATRIZ JACOBIANA LINEAL
% ================================================================
% La jacobiana lineal se obtiene derivando la posicion respecto de
% las variables articulares q1 y q2.
%
%            [ dx/dq1   dx/dq2 ]
% Jv(q)  =   [ dy/dq1   dy/dq2 ]
%            [ dz/dq1   dz/dq2 ]

Jv = [diff(x,q1)   diff(x,q2); ...
      diff(y,q1)   diff(y,q2); ...
      diff(z,q1)   diff(z,q2)];

Jv = simplify(Jv,'Steps',100);

disp('==============================================================')
disp('Matriz jacobiana lineal Jv = ')
disp(Jv)

%% ================================================================
% 9. JACOBIANA ANGULAR Y JACOBIANA COMPLETA
% ================================================================
% En un robot planar 2R, ambas articulaciones son rotativas y giran
% alrededor del eje Z de la base.
%
% Por eso, ambas aportan velocidad angular alrededor de Z:
%
% Jw = [ 0  0
%        0  0
%        1  1 ]
%
% La jacobiana completa junta velocidad lineal y angular:
%
% [ v     ]   [ Jv ] [q1_punto]
% [ omega ] = [ Jw ] [q2_punto]

Jw = [0 0; ...
      0 0; ...
      1 1];

J = [Jv; Jw];

disp('==============================================================')
disp('Matriz jacobiana angular Jw = ')
disp(Jw)

disp('Matriz jacobiana completa J = [Jv; Jw] = ')
disp(J)

%% ================================================================
% 10. INTERPRETACION DE LAS COLUMNAS DE Jv
% ================================================================
% Columna 1: efecto de mover solamente q1.
% Columna 2: efecto de mover solamente q2.

J_q1 = simplify(Jv(:,1),'Steps',100);
J_q2 = simplify(Jv(:,2),'Steps',100);

disp('==============================================================')
disp('Columna 1 de Jv: aporte de q1 = ')
disp(J_q1)

disp('Columna 2 de Jv: aporte de q2 = ')
disp(J_q2)

%% ================================================================
% 11. RELACION DE VELOCIDADES
% ================================================================
% En robotica, las velocidades disponibles son articulares.
% La jacobiana convierte velocidades articulares en velocidades
% cartesianas del efector final.
%
%       [vx]          [q1_punto]
%       [vy] = Jv(q)* [q2_punto]
%       [vz]
%
% Y la jacobiana completa permite calcular:
%
%       [vx]
%       [vy]
%       [vz]
%       [wx] = J(q)*[q1_punto; q2_punto]
%       [wy]
%       [wz]

syms q1_punto q2_punto real

q_punto = [q1_punto; q2_punto];

v_simbolica = simplify(Jv*q_punto,'Steps',100);
vel_completa_simbolica = simplify(J*q_punto,'Steps',100);

disp('==============================================================')
disp('Velocidad lineal simbolica del efector: v = Jv*q_punto = ')
disp(v_simbolica)

disp('Velocidad completa simbolica [v; omega] = J*q_punto = ')
disp(vel_completa_simbolica)

%% ================================================================
% 12. VALORES NUMERICOS DEL EJEMPLO
% ================================================================
% Configuracion actual del robot:
% l1 = 0.70 m
% l2 = 0.30 m
% q1 = -pi/2 rad
% q2 =  pi/2 rad
%
% Velocidades articulares:
% q1_punto = 0.50 rad/s
% q2_punto = 0.20 rad/s

clc

l1_val        = 0.70
l2_val        = 0.30
q1_val        = -pi/2
q2_val        =  pi/2
q1_punto_val  = 0.50
q2_punto_val  = 0.20

tol = 1e-10;

%% ================================================================
% 13. EVALUACION NUMERICA DE T, R Y POSICION
% ================================================================

T_num = double(subs(T, [l1 l2 q1 q2], [l1_val l2_val q1_val q2_val]));
T_num(abs(T_num) < tol) = 0;

R_num = double(subs(R, [l1 l2 q1 q2], [l1_val l2_val q1_val q2_val]));
R_num(abs(R_num) < tol) = 0;

pos_num = double(subs(pos, [l1 l2 q1 q2], [l1_val l2_val q1_val q2_val]));
pos_num(abs(pos_num) < tol) = 0;

disp('==============================================================')
disp('T numerica = ')
disp(T_num)

disp('Orientacion numerica R = ')
disp(R_num)

disp('Posicion numerica del efector pos = ')
disp(pos_num)

%% ================================================================
% 14. EVALUACION NUMERICA DE LA JACOBIANA
% ================================================================

Jv_num = double(subs(Jv, [l1 l2 q1 q2], [l1_val l2_val q1_val q2_val]));
Jv_num(abs(Jv_num) < tol) = 0;

J_num = double(subs(J, [l1 l2 q1 q2], [l1_val l2_val q1_val q2_val]));
J_num(abs(J_num) < tol) = 0;

disp('==============================================================')
disp('Jacobiana lineal numerica Jv = ')
disp(Jv_num)

disp('Jacobiana completa numerica J = ')
disp(J_num)

%% ================================================================
% 15. CALCULO DE VELOCIDADES FINALES
% ================================================================

q_punto_num = [q1_punto_val; q2_punto_val];

v_num = Jv_num*q_punto_num;
v_num(abs(v_num) < tol) = 0;

vel_completa_num = J_num*q_punto_num;
vel_completa_num(abs(vel_completa_num) < tol) = 0;

vx = v_num(1);
vy = v_num(2);
vz = v_num(3);

wx = vel_completa_num(4);
wy = vel_completa_num(5);
wz = vel_completa_num(6);

disp('==============================================================')
disp('Vector de velocidades articulares q_punto = ')
disp(q_punto_num)

disp('Velocidad lineal del efector [vx; vy; vz] = ')
disp(v_num)

disp('Velocidad completa del efector [vx; vy; vz; wx; wy; wz] = ')
disp(vel_completa_num)

%% ================================================================
% 16. APORTES INDIVIDUALES DE CADA ARTICULACION
% ================================================================
% La velocidad final es la suma del aporte producido por q1 y q2.

v_por_q1 = Jv_num(:,1)*q1_punto_val;
v_por_q2 = Jv_num(:,2)*q2_punto_val;

v_por_q1(abs(v_por_q1) < tol) = 0;
v_por_q2(abs(v_por_q2) < tol) = 0;

disp('==============================================================')
disp('Velocidad producida por la articulacion rotativa q1 = ')
disp(v_por_q1)

disp('Velocidad producida por la articulacion rotativa q2 = ')
disp(v_por_q2)

disp('Suma de aportes = ')
disp(v_por_q1 + v_por_q2)

%% ================================================================
% 17. SINGULARIDAD DEL ROBOT 2R
% ================================================================
% Para el movimiento planar se usa la jacobiana reducida Jxy.
% El determinante indica si la matriz puede invertirse localmente.
%
% Si det(Jxy)=0, el robot esta en una configuracion singular.

Jxy = simplify(Jv(1:2,:),'Steps',100);
detJxy = simplify(det(Jxy),'Steps',100);

detJxy_num = double(subs(detJxy, [l1 l2 q1 q2], [l1_val l2_val q1_val q2_val]));

disp('==============================================================')
disp('Jacobiana reducida planar Jxy = ')
disp(Jxy)

disp('Determinante simbolico det(Jxy) = ')
disp(detJxy)

disp('Determinante numerico det(Jxy) = ')
disp(detJxy_num)

%% ================================================================
% 18. RESUMEN FINAL EN CONSOLA
% ================================================================

fprintf('\n==============================================================\n')
fprintf('RESUMEN FINAL DEL EJEMPLO 2R\n')
fprintf('==============================================================\n')
fprintf('l1             = %.2f m\n', l1_val)
fprintf('l2             = %.2f m\n', l2_val)
fprintf('q1             = %.4f rad\n', q1_val)
fprintf('q2             = %.4f rad\n', q2_val)
fprintf('q1_punto       = %.2f rad/s\n', q1_punto_val)
fprintf('q2_punto       = %.2f rad/s\n', q2_punto_val)

fprintf('\nPosicion del efector final:\n')
fprintf('x = %.4f m\n', pos_num(1))
fprintf('y = %.4f m\n', pos_num(2))
fprintf('z = %.4f m\n', pos_num(3))

fprintf('\nVelocidad lineal del efector:\n')
fprintf('vx = %.4f m/s\n', vx)
fprintf('vy = %.4f m/s\n', vy)
fprintf('vz = %.4f m/s\n', vz)

fprintf('\nVelocidad angular del efector:\n')
fprintf('wx = %.4f rad/s\n', wx)
fprintf('wy = %.4f rad/s\n', wy)
fprintf('wz = %.4f rad/s\n', wz)

fprintf('\nDeterminante de Jxy:\n')
fprintf('det(Jxy) = %.4f\n', detJxy_num)
fprintf('==============================================================\n')

%% ================================================================
% 19. DIBUJO DEL ROBOT Y DE LAS VELOCIDADES
% ================================================================

figure
hold on
grid on
axis equal

xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')
title('Robot 2R: jacobiana y velocidades del efector final')

limite = 1.15;
xlim([-limite limite])
ylim([-limite limite])
zlim([-0.15 0.45])
view(35,25)

O  = [0;0;0];

P1 = [l1_val*cos(q1_val); ...
      l1_val*sin(q1_val); ...
      0];

P2 = pos_num;

% Robot 2R
plot3([O(1) P1(1) P2(1)], [O(2) P1(2) P2(2)], [O(3) P1(3) P2(3)], 'k-o', ...
      'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor','k')

% Velocidades
escala = 0.8;

quiver3(P2(1), P2(2), P2(3), escala*v_por_q1(1), escala*v_por_q1(2), escala*v_por_q1(3), ...
        'LineWidth', 2, 'MaxHeadSize', 0.8)

quiver3(P2(1), P2(2), P2(3), escala*v_por_q2(1), escala*v_por_q2(2), escala*v_por_q2(3), ...
        'LineWidth', 2, 'MaxHeadSize', 0.8)

quiver3(P2(1), P2(2), P2(3), escala*v_num(1), escala*v_num(2), escala*v_num(3), ...
        'LineWidth', 3, 'MaxHeadSize', 1.0)

% Ejes de base
quiver3(0,0,0,0.25,0,0,'LineWidth',2)
text(0.28,0,0,'X_0')
quiver3(0,0,0,0,0.25,0,'LineWidth',2)
text(0,0.28,0,'Y_0')
quiver3(0,0,0,0,0,0.25,'LineWidth',2)
text(0,0,0.28,'Z_0')

% Textos
text(P2(1)+escala*v_por_q1(1), P2(2)+escala*v_por_q1(2), P2(3), '  aporte q1')
text(P2(1)+escala*v_por_q2(1), P2(2)+escala*v_por_q2(2), P2(3), '  aporte q2')
text(P2(1)+escala*v_num(1),    P2(2)+escala*v_num(2),    P2(3), '  velocidad total', 'FontWeight','bold')

legend('Robot 2R','Aporte q1','Aporte q2','Velocidad total','Location','best')

hold off
