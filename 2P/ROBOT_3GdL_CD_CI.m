clc;
clear;
close all;

%% ============================================================
%  PARAMETROS DEL ROBOT
% ============================================================
l1 = 0.5;
l2 = 0.3;
l3 = 0.2;

%% ============================================================
%  CINEMATICA DIRECTA - INGRESO DE ANGULOS
% ============================================================
fprintf('\n========================================\n');
fprintf('  CINEMATICA DIRECTA\n');
fprintf('========================================\n');

q1 = input('Ingrese q1 en radianes (entre -pi y pi): ');
while (q1 < -pi || q1 > pi)
    q1 = input('  Valor invalido. Ingrese q1: ');
end

q2 = input('Ingrese q2 en radianes (entre -pi y pi): ');
while (q2 < -pi || q2 > pi)
    q2 = input('  Valor invalido. Ingrese q2: ');
end

q3 = input('Ingrese q3 en radianes (entre -pi y pi): ');
while (q3 < -pi || q3 > pi)
    q3 = input('  Valor invalido. Ingrese q3: ');
end

%% CALCULO CINEMATICA DIRECTA
r  = l2*cos(q2) + l3*cos(q2 + q3);
x  = r*cos(q1);
y  = r*sin(q1);
z  = l1 + l2*sin(q2) + l3*sin(q2 + q3);
nx = cos(q2 + q3)*cos(q1);
ny = cos(q2 + q3)*sin(q1);
nz = sin(q2 + q3);

fprintf('\n----------------------------------------\n');
fprintf('RESULTADOS DE CINEMATICA DIRECTA\n');
fprintf('----------------------------------------\n');
fprintf('Radio proyectado r = %.4f m\n', r);
fprintf('Posicion TCP:  x=%.4f  y=%.4f  z=%.4f  [m]\n', x, y, z);
fprintf('Orientacion:  nx=%.4f  ny=%.4f  nz=%.4f\n', nx, ny, nz);

%% ============================================================
%  GRAFICO ESTATICO - CINEMATICA DIRECTA
% ============================================================
P0 = [0 0 0];
P1 = [0 0 l1];
r2 = l2*cos(q2);
P2 = [r2*cos(q1), r2*sin(q1), l1+l2*sin(q2)];
P3 = [x y z];

figure('Name','Cinematica Directa - Posicion final','Color','w');
clf; hold on; grid on; axis equal; box on;

quiver3(0,0,0,0.2,0,0,0,'k','LineWidth',1.5);
quiver3(0,0,0,0,0.2,0,0,'k','LineWidth',1.5);
quiver3(0,0,0,0,0,0.2,0,'k','LineWidth',1.5);
text(0.22,0,0,'X'); text(0,0.22,0,'Y'); text(0,0,0.22,'Z');

plot3([P0(1) P1(1)],[P0(2) P1(2)],[P0(3) P1(3)],'k-','LineWidth',4);
plot3([P1(1) P2(1)],[P1(2) P2(2)],[P1(3) P2(3)],'b-','LineWidth',4);
plot3([P2(1) P3(1)],[P2(2) P3(2)],[P2(3) P3(3)],'r-','LineWidth',4);
plot3([P3(1) P3(1)],[P3(2) P3(2)],[0 P3(3)],'--','Color',[0.4 0.4 0.4],'LineWidth',1.5);
plot3([0 P3(1)],[0 P3(2)],[0 0],'--','Color',[0.6 0.6 0.6],'LineWidth',1.2);
plot3(P0(1),P0(2),P0(3),'ko','MarkerFaceColor','k','MarkerSize',8);
plot3(P1(1),P1(2),P1(3),'ko','MarkerFaceColor','k','MarkerSize',8);
plot3(P2(1),P2(2),P2(3),'ko','MarkerFaceColor','k','MarkerSize',8);
plot3(P3(1),P3(2),P3(3),'mo','MarkerFaceColor','m','MarkerSize',9);
quiver3(P3(1),P3(2),P3(3),0.15*nx,0.15*ny,0.15*nz,0,'g','LineWidth',2,'MaxHeadSize',1.5);
patch([-0.6 0.6 0.6 -0.6],[-0.6 -0.6 0.6 0.6],[0 0 0 0], ...
      [0.9 0.9 0.9],'FaceAlpha',0.15,'EdgeColor','none');

xlim([-0.6 0.6]); ylim([-0.6 0.6]); zlim([0 1.1]);
xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');
title('Robot 3 GDL - Cinematica Directa');
legend('Eje X','Eje Y','Eje Z','l1','l2','l3', ...
       'Proyec. vert.','Proyec. horiz.', ...
       'Base','Art. q2','Codo','TCP','Orientacion efector', ...
       'Location','northeastoutside');
view(135,25); rotate3d on;

%% ============================================================
%  SIMULACION - CINEMATICA DIRECTA
%  HOME (0,0,0) -> posicion ingresada
% ============================================================
Nsteps  = 150;
t_total = 5.0;
dt      = t_total / Nsteps;

q1_i = 0;  q2_i = 0;  q3_i = 0;
q1_f = q1; q2_f = q2; q3_f = q3;

traj = zeros(3, Nsteps+1);
[xi,yi,zi,~,~,~,P0s,P1s,P2s,P3s] = fk3R(l1,l2,l3,q1_i,q2_i,q3_i);
traj(:,1) = [xi;yi;zi];

figure('Name','Simulacion - Cinematica Directa', ...
       'Color',[0.12 0.12 0.15],'Position',[100 60 1000 680]);
clf; hold on; grid on; axis equal; box on;

set(gca,'Color',[0.12 0.12 0.15], ...
        'XColor',[0.55 0.55 0.60],'YColor',[0.55 0.55 0.60],'ZColor',[0.55 0.55 0.60], ...
        'GridColor',[0.30 0.30 0.35],'GridAlpha',0.4,'FontSize',10,'FontName','Consolas');

Rmax = l2+l3;  mg = 0.15;
xlim([-Rmax-mg Rmax+mg]); ylim([-Rmax-mg Rmax+mg]); zlim([0 l1+l2+l3+mg]);
xlabel('X [m]','Color',[0.75 0.75 0.80],'FontSize',11);
ylabel('Y [m]','Color',[0.75 0.75 0.80],'FontSize',11);
zlabel('Z [m]','Color',[0.75 0.75 0.80],'FontSize',11);

quiver3(0,0,0,0.14,0,0,0,'Color',[0.95 0.35 0.35],'LineWidth',2);
quiver3(0,0,0,0,0.14,0,0,'Color',[0.35 0.95 0.45],'LineWidth',2);
quiver3(0,0,0,0,0,0.14,0,'Color',[0.35 0.55 0.95],'LineWidth',2);
text(0.16,0,0,'X','Color',[0.95 0.35 0.35],'FontSize',11,'FontWeight','bold');
text(0,0.16,0,'Y','Color',[0.35 0.95 0.45],'FontSize',11,'FontWeight','bold');
text(0,0,0.16,'Z','Color',[0.35 0.55 0.95],'FontSize',11,'FontWeight','bold');
patch([-0.65 0.65 0.65 -0.65],[-0.65 -0.65 0.65 0.65],[0 0 0 0], ...
      [0.20 0.20 0.25],'FaceAlpha',0.22,'EdgeColor',[0.35 0.35 0.40],'LineStyle','--');

h_l1   = plot3([P0s(1) P1s(1)],[P0s(2) P1s(2)],[P0s(3) P1s(3)],'-','Color',[0.88 0.88 0.92],'LineWidth',6);
h_l2   = plot3([P1s(1) P2s(1)],[P1s(2) P2s(2)],[P1s(3) P2s(3)],'-','Color',[0.25 0.65 0.95],'LineWidth',6);
h_l3   = plot3([P2s(1) P3s(1)],[P2s(2) P3s(2)],[P2s(3) P3s(3)],'-','Color',[0.95 0.50 0.15],'LineWidth',6);
h_pv   = plot3([P3s(1) P3s(1)],[P3s(2) P3s(2)],[0 P3s(3)],'--','Color',[0.55 0.55 0.60],'LineWidth',1.4);
h_ph   = plot3([0 P3s(1)],[0 P3s(2)],[0 0],'--','Color',[0.40 0.40 0.45],'LineWidth',1.2);
h_P0   = plot3(P0s(1),P0s(2),P0s(3),'o','MarkerFaceColor',[0.88 0.88 0.92],'MarkerEdgeColor',[0.55 0.55 0.60],'MarkerSize',10);
h_P1   = plot3(P1s(1),P1s(2),P1s(3),'o','MarkerFaceColor',[0.88 0.88 0.92],'MarkerEdgeColor',[0.55 0.55 0.60],'MarkerSize',10);
h_P2   = plot3(P2s(1),P2s(2),P2s(3),'o','MarkerFaceColor',[0.25 0.65 0.95],'MarkerEdgeColor',[0.15 0.45 0.75],'MarkerSize',10);
h_P3   = plot3(P3s(1),P3s(2),P3s(3),'o','MarkerFaceColor',[0.95 0.50 0.15],'MarkerEdgeColor',[0.75 0.30 0.05],'MarkerSize',12);
t_P2   = text(P2s(1),P2s(2),P2s(3),'  Codo','Color',[0.40 0.80 1.00],'FontSize',10,'FontWeight','bold','FontName','Consolas');
t_P3   = text(P3s(1),P3s(2),P3s(3),'  TCP', 'Color',[1.00 0.65 0.25],'FontSize',10,'FontWeight','bold','FontName','Consolas');
h_traj = plot3(traj(1,1),traj(2,1),traj(3,1),'-','Color',[0.95 0.25 0.35],'LineWidth',2);
[~,~,~,nx0,ny0,nz0,~,~,~,~] = fk3R(l1,l2,l3,0,0,0);
h_ori  = quiver3(P3s(1),P3s(2),P3s(3),0.12*nx0,0.12*ny0,0.12*nz0, ...
                 0,'Color',[0.25 0.95 0.55],'LineWidth',2.5,'MaxHeadSize',1.8);
hTxt   = annotation('textbox',[0.01 0.02 0.28 0.20], ...
         'String',{'','','','',''},'FitBoxToText','off', ...
         'EdgeColor',[0.30 0.30 0.35],'BackgroundColor',[0.14 0.14 0.17], ...
         'Color',[0.85 0.85 0.90],'FontSize',9,'FontName','Consolas');

view(135,25); rotate3d on;
fprintf('\nIniciando simulacion cinematica directa...\n');

for k = 1:Nsteps
    a  = k/Nsteps;  a = 3*a^2 - 2*a^3;
    q1k = (1-a)*q1_i + a*q1_f;
    q2k = (1-a)*q2_i + a*q2_f;
    q3k = (1-a)*q3_i + a*q3_f;
    [xk,yk,zk,nxk,nyk,nzk,P0k,P1k,P2k,P3k] = fk3R(l1,l2,l3,q1k,q2k,q3k);
    traj(:,k+1) = [xk;yk;zk];

    set(h_l1,'XData',[P0k(1) P1k(1)],'YData',[P0k(2) P1k(2)],'ZData',[P0k(3) P1k(3)]);
    set(h_l2,'XData',[P1k(1) P2k(1)],'YData',[P1k(2) P2k(2)],'ZData',[P1k(3) P2k(3)]);
    set(h_l3,'XData',[P2k(1) P3k(1)],'YData',[P2k(2) P3k(2)],'ZData',[P2k(3) P3k(3)]);
    set(h_pv,'XData',[P3k(1) P3k(1)],'YData',[P3k(2) P3k(2)],'ZData',[0 P3k(3)]);
    set(h_ph,'XData',[0 P3k(1)],'YData',[0 P3k(2)],'ZData',[0 0]);
    set(h_P0,'XData',P0k(1),'YData',P0k(2),'ZData',P0k(3));
    set(h_P1,'XData',P1k(1),'YData',P1k(2),'ZData',P1k(3));
    set(h_P2,'XData',P2k(1),'YData',P2k(2),'ZData',P2k(3));
    set(h_P3,'XData',P3k(1),'YData',P3k(2),'ZData',P3k(3));
    set(t_P2,'Position',[P2k(1) P2k(2) P2k(3)]);
    set(t_P3,'Position',[P3k(1) P3k(2) P3k(3)]);
    set(h_traj,'XData',traj(1,1:k+1),'YData',traj(2,1:k+1),'ZData',traj(3,1:k+1));
    set(h_ori,'XData',P3k(1),'YData',P3k(2),'ZData',P3k(3), ...
              'UData',0.12*nxk,'VData',0.12*nyk,'WData',0.12*nzk);
    set(hTxt,'String',{ ...
        sprintf('  q1 = %+.3f rad (%+.1f deg)',q1k,rad2deg(q1k)), ...
        sprintf('  q2 = %+.3f rad (%+.1f deg)',q2k,rad2deg(q2k)), ...
        sprintf('  q3 = %+.3f rad (%+.1f deg)',q3k,rad2deg(q3k)), ...
        sprintf('  x = %+.4f m   y = %+.4f m',xk,yk), ...
        sprintf('  z = %+.4f m',zk)});
    title(sprintf('Cinematica Directa  |  q1=%.1f  q2=%.1f  q3=%.1f  [deg]', ...
          rad2deg(q1k),rad2deg(q2k),rad2deg(q3k)), ...
          'Color',[0.90 0.90 0.95],'FontSize',12,'FontName','Consolas');
    drawnow; pause(dt);
end

fprintf('\n========================================\n');
fprintf('  SIMULACION CD FINALIZADA\n');
fprintf('  TCP: x=%.4f  y=%.4f  z=%.4f [m]\n',x,y,z);
fprintf('========================================\n\n');

%% ============================================================
%  CINEMATICA INVERSA - INGRESO DE COORDENADAS
% ============================================================
fprintf('\n========================================\n');
fprintf('  CINEMATICA INVERSA\n');
fprintf('========================================\n');

% Limites globales de las coordenadas del TCP
x_min = -0.5;   % en metros
x_max =  0.5;   % en metros

y_min = -0.5;   % en metros
y_max =  0.5;   % en metros

z_min =  0.0;   % en metros
z_max =  1.0;   % en metros

% Ingreso de coordenadas deseadas
x_d = input('Ingrese x deseado del TCP [m] (entre -0.5 y 0.5): ');
while (x_d < x_min || x_d > x_max)
    x_d = input('Valor invalido. Ingrese x [m] entre -0.5 y 0.5: ');
end

y_d = input('Ingrese y deseado del TCP [m] (entre -0.5 y 0.5): ');
while (y_d < y_min || y_d > y_max)
    y_d = input('Valor invalido. Ingrese y [m] entre -0.5 y 0.5: ');
end

z_d = input('Ingrese z deseado del TCP [m] (entre 0 y 1.0): ');
while (z_d < z_min || z_d > z_max)
    z_d = input('Valor invalido. Ingrese z [m] entre 0 y 1.0: ');
end

% Magnitudes auxiliares
r_d      = sqrt(x_d^2 + y_d^2);
Pz_d     = z_d - l1;
q1_inv   = atan2(y_d, x_d);

% Verificacion de volumen de trabajo
alcance2 = x_d^2 + y_d^2 + (z_d - l1)^2;   % distancia al hombro, al cuadrado
rmin2    = (l2 - l3)^2;                    % radio interno, al cuadrado
rmax2    = (l2 + l3)^2;                    % radio externo, al cuadrado

while (alcance2 < rmin2 || alcance2 > rmax2)
    fprintf('\nERROR: el punto ingresado esta fuera del volumen de trabajo.\n');
    fprintf('Debe cumplirse: %.4f <= x^2 + y^2 + (z-l1)^2 <= %.4f\n', rmin2, rmax2);

    x_d = input('Reingrese x [m] (entre -0.5 y 0.5): ');
    while (x_d < x_min || x_d > x_max)
        x_d = input('Valor invalido. Ingrese x [m] entre -0.5 y 0.5: ');
    end

    y_d = input('Reingrese y [m] (entre -0.5 y 0.5): ');
    while (y_d < y_min || y_d > y_max)
        y_d = input('Valor invalido. Ingrese y [m] entre -0.5 y 0.5: ');
    end

    z_d = input('Reingrese z [m] (entre 0 y 1.0): ');
    while (z_d < z_min || z_d > z_max)
        z_d = input('Valor invalido. Ingrese z [m] entre 0 y 1.0: ');
    end

    r_d      = sqrt(x_d^2 + y_d^2);
    Pz_d     = z_d - l1;
    q1_inv   = atan2(y_d, x_d);
    alcance2 = x_d^2 + y_d^2 + (z_d - l1)^2;
end
%% CALCULO DE q3
cos_q3        = (x_d^2 + y_d^2 + (z_d-l1)^2 - l2^2 - l3^2) / (2*l2*l3); %CALCULA EL COS DE Q3
cos_q3        = max(-1, min(1, cos_q3)); % LIMITA EL COS DE Q3 ENTRE -1 Y 1 PARA QUE NO SE ROMPA EL CODIGO
q3_abajo      = atan2( sqrt(1-cos_q3^2), cos_q3);
q3_arriba     = atan2(-sqrt(1-cos_q3^2), cos_q3);

%% CALCULO DE beta, alpha (PARA CALCULAR Q2), q2
beta          = atan2(Pz_d, r_d);
alpha_abajo   = atan2(l3*sin(q3_abajo),  l2+l3*cos(q3_abajo)); 
alpha_arriba  = atan2(l3*sin(q3_arriba), l2+l3*cos(q3_arriba));
q2_abajo      = beta - alpha_abajo;
q2_arriba     = beta - alpha_arriba;

%% RESULTADOS EN CONSOLA
fprintf('\n----------------------------------------\n');
fprintf('RESULTADOS CINEMATICA INVERSA\n');
fprintf('----------------------------------------\n');
fprintf('cos(q3) = %.6f\n\n', cos_q3);
fprintf('q1        = %.4f rad  (%.2f deg)\n\n', q1_inv, rad2deg(q1_inv));
fprintf('CODO ABAJO:\n');
fprintf('  q2 = %.4f rad  (%.2f deg)\n', q2_abajo,  rad2deg(q2_abajo));
fprintf('  q3 = %.4f rad  (%.2f deg)\n', q3_abajo,  rad2deg(q3_abajo));
fprintf('\nCODO ARRIBA:\n');
fprintf('  q2 = %.4f rad  (%.2f deg)\n', q2_arriba, rad2deg(q2_arriba));
fprintf('  q3 = %.4f rad  (%.2f deg)\n', q3_arriba, rad2deg(q3_arriba));

%% VERIFICACION
rv_ab = l2*cos(q2_abajo)  + l3*cos(q2_abajo  + q3_abajo);  %AALCANCE HORIZONTAL CODO ABAJO
rv_ar = l2*cos(q2_arriba) + l3*cos(q2_arriba + q3_arriba);  %ALCANCE HORIZONTAL CODO ARRIBA

%POSICION CODO ABAJO
x_ab = rv_ab*cos(q1_inv);
y_ab = rv_ab*sin(q1_inv);
z_ab = l1 + l2*sin(q2_abajo)  + l3*sin(q2_abajo  + q3_abajo);

%POSICION CODO ARRIBA
x_ar = rv_ar*cos(q1_inv);
y_ar = rv_ar*sin(q1_inv);
z_ar = l1 + l2*sin(q2_arriba) + l3*sin(q2_arriba + q3_arriba);

% Usamos todos como vectores columna para evitar errores de dimensiones
TCP_ab = [x_ab; y_ab; z_ab];
TCP_ar = [x_ar; y_ar; z_ar];
TCP_d  = [x_d; y_d; z_d]; % TCP DESEADO POR EL USUARIO

%ERRORES DEL PUNTO RECONTRUIDO Y EL DESEADO
err_ab = norm(TCP_ab - TCP_d);
err_ar = norm(TCP_ar - TCP_d);

fprintf('\n----------------------------------------\n');
fprintf('VERIFICACION\n');
fprintf('----------------------------------------\n');

fprintf('\nCodo abajo:\n');
fprintf('x = %.6f m\n', x_ab);
fprintf('y = %.6f m\n', y_ab);
fprintf('z = %.6f m\n', z_ab);
fprintf('Error codo abajo  = %.2e m\n', err_ab);

fprintf('\nCodo arriba:\n');
fprintf('x = %.6f m\n', x_ar);
fprintf('y = %.6f m\n', y_ar);
fprintf('z = %.6f m\n', z_ar);
fprintf('Error codo arriba = %.2e m\n', err_ar);

%% ============================================================
%  SIMULACION - CINEMATICA INVERSA
%  Figura unica con dos subplots lado a lado.
%  Izquierda = codo abajo (trayectoria verde)
%  Derecha   = codo arriba (trayectoria magenta)
%  Ambos parten de HOME y llegan al mismo TCP (estrella amarilla)
% ============================================================
Nsteps  = 150;
t_total = 5.0;
dt      = t_total / Nsteps;
q1_i = 0;  q2_i = 0;  q3_i = 0;

traj_ab = zeros(3,Nsteps+1);
traj_ar = zeros(3,Nsteps+1);
[xi,yi,zi,~,~,~,Ph0,Ph1,Ph2,Ph3] = fk3R(l1,l2,l3,0,0,0);
traj_ab(:,1) = [xi;yi;zi];
traj_ar(:,1) = [xi;yi;zi];

cL1  = [0.88 0.88 0.92];
cL2  = [0.30 0.70 1.00];
cL3  = [1.00 0.55 0.15];
cBG  = [0.10 0.10 0.13];
cGrd = [0.25 0.25 0.30];
cAx  = [0.55 0.55 0.60];
cTxt = [0.80 0.80 0.85];

figure('Name','Cinematica Inversa - Codo abajo vs Codo arriba', ...
       'Color',cBG,'Position',[40 40 1380 700]);
clf;

% -- subplot izquierdo: CODO ABAJO --
ax1 = subplot(1,2,1);
hold on; grid on; axis equal; box on;
set(ax1,'Color',cBG,'XColor',cAx,'YColor',cAx,'ZColor',cAx, ...
        'GridColor',cGrd,'GridAlpha',0.35,'FontSize',9,'FontName','Consolas');
xlim([-Rmax-mg Rmax+mg]); ylim([-Rmax-mg Rmax+mg]); zlim([0 l1+l2+l3+mg]);
xlabel('X [m]','Color',cTxt); ylabel('Y [m]','Color',cTxt); zlabel('Z [m]','Color',cTxt);

% ejes y plano base
quiver3(0,0,0,0.12,0,0,0,'Color',[0.95 0.35 0.35],'LineWidth',1.6);
quiver3(0,0,0,0,0.12,0,0,'Color',[0.35 0.95 0.45],'LineWidth',1.6);
quiver3(0,0,0,0,0,0.12,0,'Color',[0.35 0.55 0.95],'LineWidth',1.6);
patch([-0.65 0.65 0.65 -0.65],[-0.65 -0.65 0.65 0.65],[0 0 0 0], ...
      [0.17 0.17 0.20],'FaceAlpha',0.25,'EdgeColor',[0.30 0.30 0.35],'LineStyle','--');

% TCP objetivo (fijo)
plot3(x_d,y_d,z_d,'p','Color',[1 0.9 0.1],'MarkerFaceColor',[1 0.9 0.1],'MarkerSize',14);
text(x_d+0.02,y_d+0.02,z_d+0.02,'TCP objetivo','Color',[1 0.9 0.1], ...
     'FontSize',9,'FontWeight','bold','FontName','Consolas');

% eslabones animados
s1l1 = plot3([Ph0(1) Ph1(1)],[Ph0(2) Ph1(2)],[Ph0(3) Ph1(3)],'-','Color',cL1,'LineWidth',6);
s1l2 = plot3([Ph1(1) Ph2(1)],[Ph1(2) Ph2(2)],[Ph1(3) Ph2(3)],'-','Color',cL2,'LineWidth',6);
s1l3 = plot3([Ph2(1) Ph3(1)],[Ph2(2) Ph3(2)],[Ph2(3) Ph3(3)],'-','Color',cL3,'LineWidth',6);
s1j0 = plot3(Ph0(1),Ph0(2),Ph0(3),'o','MarkerFaceColor',cL1,'MarkerEdgeColor',cAx,'MarkerSize',9);
s1j1 = plot3(Ph1(1),Ph1(2),Ph1(3),'o','MarkerFaceColor',cL1,'MarkerEdgeColor',cAx,'MarkerSize',9);
s1j2 = plot3(Ph2(1),Ph2(2),Ph2(3),'o','MarkerFaceColor',cL2,'MarkerEdgeColor',[0.15 0.45 0.75],'MarkerSize',9);
s1j3 = plot3(Ph3(1),Ph3(2),Ph3(3),'o','MarkerFaceColor',cL3,'MarkerEdgeColor',[0.75 0.30 0.05],'MarkerSize',11);
s1tc = text(Ph2(1),Ph2(2),Ph2(3),'  Codo','Color',cL2,'FontSize',9,'FontWeight','bold','FontName','Consolas');
s1tp = text(Ph3(1),Ph3(2),Ph3(3),'  TCP', 'Color',cL3,'FontSize',9,'FontWeight','bold','FontName','Consolas');
s1tr = plot3(nan,nan,nan,'-','Color',[0.20 0.90 0.50],'LineWidth',2);

title('Codo abajo','Color',[0.25 0.95 0.55],'FontSize',13,'FontName','Consolas');
view(135,25); rotate3d on;

% -- subplot derecho: CODO ARRIBA --
ax2 = subplot(1,2,2);
hold on; grid on; axis equal; box on;
set(ax2,'Color',cBG,'XColor',cAx,'YColor',cAx,'ZColor',cAx, ...
        'GridColor',cGrd,'GridAlpha',0.35,'FontSize',9,'FontName','Consolas');
xlim([-Rmax-mg Rmax+mg]); ylim([-Rmax-mg Rmax+mg]); zlim([0 l1+l2+l3+mg]);
xlabel('X [m]','Color',cTxt); ylabel('Y [m]','Color',cTxt); zlabel('Z [m]','Color',cTxt);

quiver3(0,0,0,0.12,0,0,0,'Color',[0.95 0.35 0.35],'LineWidth',1.6);
quiver3(0,0,0,0,0.12,0,0,'Color',[0.35 0.95 0.45],'LineWidth',1.6);
quiver3(0,0,0,0,0,0.12,0,'Color',[0.35 0.55 0.95],'LineWidth',1.6);
patch([-0.65 0.65 0.65 -0.65],[-0.65 -0.65 0.65 0.65],[0 0 0 0], ...
      [0.17 0.17 0.20],'FaceAlpha',0.25,'EdgeColor',[0.30 0.30 0.35],'LineStyle','--');

plot3(x_d,y_d,z_d,'p','Color',[1 0.9 0.1],'MarkerFaceColor',[1 0.9 0.1],'MarkerSize',14);
text(x_d+0.02,y_d+0.02,z_d+0.02,'TCP objetivo','Color',[1 0.9 0.1], ...
     'FontSize',9,'FontWeight','bold','FontName','Consolas');

s2l1 = plot3([Ph0(1) Ph1(1)],[Ph0(2) Ph1(2)],[Ph0(3) Ph1(3)],'-','Color',cL1,'LineWidth',6);
s2l2 = plot3([Ph1(1) Ph2(1)],[Ph1(2) Ph2(2)],[Ph1(3) Ph2(3)],'-','Color',cL2,'LineWidth',6);
s2l3 = plot3([Ph2(1) Ph3(1)],[Ph2(2) Ph3(2)],[Ph2(3) Ph3(3)],'-','Color',cL3,'LineWidth',6);
s2j0 = plot3(Ph0(1),Ph0(2),Ph0(3),'o','MarkerFaceColor',cL1,'MarkerEdgeColor',cAx,'MarkerSize',9);
s2j1 = plot3(Ph1(1),Ph1(2),Ph1(3),'o','MarkerFaceColor',cL1,'MarkerEdgeColor',cAx,'MarkerSize',9);
s2j2 = plot3(Ph2(1),Ph2(2),Ph2(3),'o','MarkerFaceColor',cL2,'MarkerEdgeColor',[0.15 0.45 0.75],'MarkerSize',9);
s2j3 = plot3(Ph3(1),Ph3(2),Ph3(3),'o','MarkerFaceColor',cL3,'MarkerEdgeColor',[0.75 0.30 0.05],'MarkerSize',11);
s2tc = text(Ph2(1),Ph2(2),Ph2(3),'  Codo','Color',cL2,'FontSize',9,'FontWeight','bold','FontName','Consolas');
s2tp = text(Ph3(1),Ph3(2),Ph3(3),'  TCP', 'Color',cL3,'FontSize',9,'FontWeight','bold','FontName','Consolas');
s2tr = plot3(nan,nan,nan,'-','Color',[0.95 0.25 0.65],'LineWidth',2);

title('Codo arriba','Color',[0.95 0.35 0.65],'FontSize',13,'FontName','Consolas');
view(135,25); rotate3d on;

% -- ANIMACION DOBLE --
fprintf('\nIniciando simulacion cinematica inversa...\n');

for k = 1:Nsteps
    a    = k/Nsteps;  a = 3*a^2 - 2*a^3;
    q1k  = (1-a)*q1_i + a*q1_inv;
    q2kA = (1-a)*q2_i + a*q2_abajo;
    q3kA = (1-a)*q3_i + a*q3_abajo;
    q2kB = (1-a)*q2_i + a*q2_arriba;
    q3kB = (1-a)*q3_i + a*q3_arriba;

    [xA,yA,zA,~,~,~,P0A,P1A,P2A,P3A] = fk3R(l1,l2,l3,q1k,q2kA,q3kA);
    [xB,yB,zB,~,~,~,P0B,P1B,P2B,P3B] = fk3R(l1,l2,l3,q1k,q2kB,q3kB);

    traj_ab(:,k+1) = [xA;yA;zA];
    traj_ar(:,k+1) = [xB;yB;zB];

    % actualizar codo abajo
    set(s1l1,'XData',[P0A(1) P1A(1)],'YData',[P0A(2) P1A(2)],'ZData',[P0A(3) P1A(3)]);
    set(s1l2,'XData',[P1A(1) P2A(1)],'YData',[P1A(2) P2A(2)],'ZData',[P1A(3) P2A(3)]);
    set(s1l3,'XData',[P2A(1) P3A(1)],'YData',[P2A(2) P3A(2)],'ZData',[P2A(3) P3A(3)]);
    set(s1j0,'XData',P0A(1),'YData',P0A(2),'ZData',P0A(3));
    set(s1j1,'XData',P1A(1),'YData',P1A(2),'ZData',P1A(3));
    set(s1j2,'XData',P2A(1),'YData',P2A(2),'ZData',P2A(3));
    set(s1j3,'XData',P3A(1),'YData',P3A(2),'ZData',P3A(3));
    set(s1tc,'Position',[P2A(1) P2A(2) P2A(3)]);
    set(s1tp,'Position',[P3A(1) P3A(2) P3A(3)]);
    set(s1tr,'XData',traj_ab(1,1:k+1),'YData',traj_ab(2,1:k+1),'ZData',traj_ab(3,1:k+1));

    % actualizar codo arriba
    set(s2l1,'XData',[P0B(1) P1B(1)],'YData',[P0B(2) P1B(2)],'ZData',[P0B(3) P1B(3)]);
    set(s2l2,'XData',[P1B(1) P2B(1)],'YData',[P1B(2) P2B(2)],'ZData',[P1B(3) P2B(3)]);
    set(s2l3,'XData',[P2B(1) P3B(1)],'YData',[P2B(2) P3B(2)],'ZData',[P2B(3) P3B(3)]);
    set(s2j0,'XData',P0B(1),'YData',P0B(2),'ZData',P0B(3));
    set(s2j1,'XData',P1B(1),'YData',P1B(2),'ZData',P1B(3));
    set(s2j2,'XData',P2B(1),'YData',P2B(2),'ZData',P2B(3));
    set(s2j3,'XData',P3B(1),'YData',P3B(2),'ZData',P3B(3));
    set(s2tc,'Position',[P2B(1) P2B(2) P2B(3)]);
    set(s2tp,'Position',[P3B(1) P3B(2) P3B(3)]);
    set(s2tr,'XData',traj_ar(1,1:k+1),'YData',traj_ar(2,1:k+1),'ZData',traj_ar(3,1:k+1));

    % titulos dinamicos
    title(ax1, sprintf('Codo abajo  |  q2=%.1f  q3=%.1f  [deg]', ...
          rad2deg(q2kA),rad2deg(q3kA)), ...
          'Color',[0.25 0.95 0.55],'FontSize',11,'FontName','Consolas');
    title(ax2, sprintf('Codo arriba  |  q2=%.1f  q3=%.1f  [deg]', ...
          rad2deg(q2kB),rad2deg(q3kB)), ...
          'Color',[0.95 0.35 0.65],'FontSize',11,'FontName','Consolas');

    drawnow; pause(dt);
end

fprintf('\n========================================\n');
fprintf('  SIMULACION CI FINALIZADA\n');
fprintf('  TCP objetivo: x=%.4f  y=%.4f  z=%.4f [m]\n',x_d,y_d,z_d);
fprintf('========================================\n\n');

%% ============================================================
%  FUNCION AUXILIAR - CINEMATICA DIRECTA
%  DEBE SER SIEMPRE LA ULTIMA SECCION DEL ARCHIVO
% ============================================================
function [x, y, z, nx, ny, nz, P0, P1, P2, P3] = fk3R(l1, l2, l3, q1, q2, q3)
    r  = l2*cos(q2) + l3*cos(q2+q3);
    x  = r*cos(q1);
    y  = r*sin(q1);
    z  = l1 + l2*sin(q2) + l3*sin(q2+q3);
    nx = cos(q2+q3)*cos(q1);
    ny = cos(q2+q3)*sin(q1);
    nz = sin(q2+q3);
    P0 = [0, 0, 0];
    P1 = [0, 0, l1];
    r2 = l2*cos(q2);
    P2 = [r2*cos(q1), r2*sin(q1), l1+l2*sin(q2)];
    P3 = [x, y, z];
end




