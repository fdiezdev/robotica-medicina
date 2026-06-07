%% ================================================================
% MATRIZ JACOBIANA A PARTIR DE DENAVIT-HARTENBERG
% Robot R-P: articulacion Rotativa + articulacion Prismatica
%
% Este programa acompania el apunte de clase:
% 1) Construye las matrices D-H A01 y A12.
% 2) Obtiene la matriz homogenea total T = A01*A12.
% 3) Extrae posicion y orientacion del efector final.
% 4) Calcula la matriz jacobiana lineal Jv.
% 5) Evalua un ejemplo numerico.
% 6) Calcula las velocidades finales vx, vy, vz.
% 7) Dibuja el robot y las velocidades radial, tangencial y total.
% ================================================================

close all; clear all; clc
format bank

%% ================================================================
% 1. VARIABLES SIMBOLICAS
% ================================================================

syms q1 p L real
medio_pi = sym(pi)/2;

%% ================================================================
% 2. PARAMETROS DE DENAVIT-HARTENBERG
% ================================================================
% Tabla D-H usada:
%
% i       theta_i          d_i        a_i       alpha_i
% ------------------------------------------------------
% 1       pi/2 + q1        0          0         pi/2
% 2       0                L+p        0         0
%
% q1: variable rotativa
% p : variable prismatica
% L : longitud fija

q    = [medio_pi + q1   0]
d    = [0               L+p]
a    = [0               0]
alfa = [medio_pi        0]

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
% T no multiplica al vector [q1; p].
% T depende de q1 y p, y multiplica puntos homogeneos.

T = simplify(A01*A12,'Steps',100);

disp('==============================================================')
disp('T simbolica = A01*A12 = ')
disp(T)

disp('T en formato pretty = ')
pretty(T)

%% ================================================================
% 6. POSICION Y ORIENTACION DEL EFECTOR FINAL
% ================================================================
% R   = orientacion del efector final
% pos = posicion del efector final

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
% La jacobiana se obtiene derivando la posicion respecto de las
% variables articulares q1 y p.
%
%            [ dx/dq1   dx/dp ]
% Jv(q)  =   [ dy/dq1   dy/dp ]
%            [ dz/dq1   dz/dp ]

Jv = [diff(x,q1)   diff(x,p); ...
      diff(y,q1)   diff(y,p); ...
      diff(z,q1)   diff(z,p)];

Jv = simplify(Jv,'Steps',100);

disp('==============================================================')
disp('Matriz jacobiana lineal Jv = ')
disp(Jv)

%% ================================================================
% 9. INTERPRETACION DE LAS COLUMNAS DE Jv
% ================================================================
% Columna 1: efecto de la articulacion rotativa q1.
% Columna 2: efecto de la articulacion prismatica p.

J_q1 = simplify(Jv(:,1),'Steps',100);
J_p  = simplify(Jv(:,2),'Steps',100);

disp('==============================================================')
disp('Columna 1 de Jv: aporte de q1 = ')
disp(J_q1)

disp('Columna 2 de Jv: aporte de p = ')
disp(J_p)

%% ================================================================
% 10. RELACION DE VELOCIDADES
% ================================================================
% En MRU: velocidad sobre un eje = v.
% En robotica: las velocidades disponibles son articulares.
% La jacobiana convierte velocidades articulares en velocidades
% cartesianas del efector final.
%
%       [vx]          [q1_punto]
%       [vy] = Jv(q)* [p_punto ]
%       [vz]

syms q1_punto p_punto real

q_punto = [q1_punto; p_punto];
v_simbolica = simplify(Jv*q_punto,'Steps',100);

disp('==============================================================')
disp('Velocidad simbolica del efector: v = Jv*q_punto = ')
disp(v_simbolica)

%% ================================================================
% 11. VALORES NUMERICOS DEL EJEMPLO DEL APUNTE
% ================================================================
% Configuracion actual del robot:
% L  = 0.70 m
% p  = 0.30 m
% q1 = pi/7 rad
%
% Velocidades articulares:
% q1_punto = 0.50 rad/s
% p_punto  = 0.10 m/s
clc

L_val        = 0.7
p_val        = 0.30
q1_val       = pi/7
q1_punto_val = 0.50 % radianes /seg
p_punto_val  = 0.10 % metro/s

tol = 1e-10;

%% ================================================================
% 12. EVALUACION NUMERICA DE T, R Y POSICION
% ================================================================

T_num = double(subs(T, [L q1 p], [L_val q1_val p_val]));
T_num(abs(T_num) < tol) = 0;

R_num = double(subs(R, [L q1 p], [L_val q1_val p_val]));
R_num(abs(R_num) < tol) = 0;

pos_num = double(subs(pos, [L q1 p], [L_val q1_val p_val]));
pos_num(abs(pos_num) < tol) = 0;

disp('==============================================================')
disp('T numerica = ')
disp(T_num)

disp('Orientacion numerica R = ')
disp(R_num)

disp('Posicion numerica del efector pos = ')
disp(pos_num)

%% ================================================================
% 13. EVALUACION NUMERICA DE LA JACOBIANA
% ================================================================

Jv_num = double(subs(Jv, [L q1 p], [L_val q1_val p_val]));
Jv_num(abs(Jv_num) < tol) = 0;

disp('==============================================================')
disp('Jacobiana numerica Jv = ')
disp(Jv_num)

%% ================================================================
% 14. CALCULO DE VELOCIDADES FINALES vx, vy, vz
% ================================================================

q_punto_num = [q1_punto_val; p_punto_val];
v_num = Jv_num*q_punto_num;
v_num(abs(v_num) < tol) = 0;

vx = v_num(1);
vy = v_num(2);
vz = v_num(3);

disp('==============================================================')
disp('Vector de velocidades articulares q_punto = ')
disp(q_punto_num)

disp('Velocidad final del efector [vx; vy; vz] = ')
disp(v_num)

%% ================================================================
% 15. APORTES INDIVIDUALES DE CADA ARTICULACION
% ================================================================
% La velocidad final es la suma del aporte rotativo y prismático.

v_por_q1 = Jv_num(:,1)*q1_punto_val;
v_por_p  = Jv_num(:,2)*p_punto_val;

v_por_q1(abs(v_por_q1) < tol) = 0;
v_por_p(abs(v_por_p) < tol) = 0;

disp('==============================================================')
disp('Velocidad producida por la articulacion rotativa q1 = ')
disp(v_por_q1)

disp('Velocidad producida por la articulacion prismatica p = ')
disp(v_por_p)

disp('Suma de aportes = ')
disp(v_por_q1 + v_por_p)

%% ================================================================
% 16. RESUMEN FINAL EN CONSOLA
% ================================================================

fprintf('\n==============================================================\n')
fprintf('RESUMEN FINAL DEL EJEMPLO\n')
fprintf('==============================================================\n')
fprintf('L              = %.2f m\n', L_val)
fprintf('p              = %.2f m\n', p_val)
fprintf('q1             = %.4f rad\n', q1_val)
fprintf('q1_punto       = %.2f rad/s\n', q1_punto_val)
fprintf('p_punto        = %.2f m/s\n', p_punto_val)
fprintf('\nPosicion del efector final:\n')
fprintf('x = %.4f m\n', pos_num(1))
fprintf('y = %.4f m\n', pos_num(2))
fprintf('z = %.4f m\n', pos_num(3))
fprintf('\nVelocidad final del efector:\n')
fprintf('vx = %.4f m/s\n', vx)
fprintf('vy = %.4f m/s\n', vy)
fprintf('vz = %.4f m/s\n', vz)
fprintf('==============================================================\n')

%% ================================================================
% 17. DIBUJO DEL ROBOT Y DE LAS VELOCIDADES
% ================================================================

figure
hold on
grid on
axis equal

xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')
title('Robot R-P: jacobiana y velocidades del efector final')

limite = 1.25;
xlim([-limite limite])
ylim([-limite limite])
zlim([-0.15 0.45])
view(35,25)

O = [0;0;0];
P = pos_num;

% Robot
plot3([O(1) P(1)], [O(2) P(2)], [O(3) P(3)], 'k-o', ...
      'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor','k')

% Velocidades
escala = 0.8;

quiver3(P(1), P(2), P(3), escala*v_por_q1(1), escala*v_por_q1(2), escala*v_por_q1(3), ...
        'LineWidth', 2, 'MaxHeadSize', 0.8)

quiver3(P(1), P(2), P(3), escala*v_por_p(1), escala*v_por_p(2), escala*v_por_p(3), ...
        'LineWidth', 2, 'MaxHeadSize', 0.8)

quiver3(P(1), P(2), P(3), escala*v_num(1), escala*v_num(2), escala*v_num(3), ...
        'LineWidth', 3, 'MaxHeadSize', 1.0)

% Ejes de base
quiver3(0,0,0,0.25,0,0,'LineWidth',2)
text(0.28,0,0,'X_0')
quiver3(0,0,0,0,0.25,0,'LineWidth',2)
text(0,0.28,0,'Y_0')
quiver3(0,0,0,0,0,0.25,'LineWidth',2)
text(0,0,0.28,'Z_0')

% Textos
text(P(1)+escala*v_por_q1(1), P(2)+escala*v_por_q1(2), P(3), '  aporte q1')
text(P(1)+escala*v_por_p(1),  P(2)+escala*v_por_p(2),  P(3), '  aporte p')
text(P(1)+escala*v_num(1),    P(2)+escala*v_num(2),    P(3), '  velocidad total', 'FontWeight','bold')

legend('Robot R-P','Aporte q1','Aporte p','Velocidad total','Location','best')

hold off
