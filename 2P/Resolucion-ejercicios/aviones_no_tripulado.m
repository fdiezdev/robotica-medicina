%% problema avion *************************************************************************
close all; clear all; clc
% hacerlo
%% MATRIZ DE TRASLACIÓN
syms dx
trax=[1 0 0 4000;...
   0 1 0 -2000;...
   0 0 1 1000;...
   0 0 0 1]
%%
p=[2000 0 500 1]'
%%
p1=(trax*rotz)*p %
%%
% a donde se encuentra el sistema de tierra considerando el fijo al avión y
% el modificado a la tierra
A= inv (trax*rotz)
%%
p3= A*[3000 5000 350 1]'
%% ejemplo 3.4  del libro de Barrientos pagina 71
%rotación en X
close all; clear all; clc
syms alfa
alfa= pi/2 ;
rotx=[1 0 0 0;...
   0 cos(alfa) -sin(alfa) 0;...
   0 sin(alfa) cos(alfa) 0;...
   0 0 0 1]
%%
syms dx
trax=[1 0 0 8;...
   0 1 0 -4;...
   0 0 1 12;...
   0 0 0 1]
%%
r=[-3 4 -11 1]'
P0= trax*rotx*r
%% que pasa ahora si primero hacemos la traslación y luegola rotación
p1=rotx*trax*r
%% ejemplo 3.6 pagina 75 libro de Barrientos
% primero - 90 grados con respeco a x, traslacion de (5 5 10 1) Y YNA ROT
%(z+90)
%rotación en X
close all; clear all; clc
syms alfa
alfa= -pi/2 ;
rotx=[1 0 0 0;...
   0 cos(alfa) -sin(alfa) 0;...
   0 sin(alfa) cos(alfa) 0;...
   0 0 0 1]
%% AHOARA LA TRASLACIÓN DE (5 5 10 1)
syms dx
trax=[1 0 0 5;...
   0 1 0 5;...
   0 0 1 10;...
   0 0 0 1]
%% FINALMENTE LA ROTACION EN Z DE +90
%ROTACIÓN EN EL EJE Z
syms gama
gama= pi/2; % +90 GRADOS
rotz=[cos(gama) -sin(gama) 0 0;...
   sin(gama)  cos(gama)  0 0;...
   0 0 1 0;...
   0 0 0 1]
%% LA COMPOSICIÓN QUEDA
rotz*trax*rotx
%%
