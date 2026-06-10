%% EJERCICIO AVION
close all; clear all; clc
format bank
%ROTACIÓN EN EL EJE Z
syms gama
rotz=[cos(gama) -sin(gama) 0 0;...
   sin(gama)  cos(gama)  0 0;...
   0 0 1 0;...
   0 0 0 1]
%%
gama= pi % 180 GRADOS
rotzz =eval (rotz)
%%
tras=[1 0 0 300;...
   0 1 0 1000;...
   0 0 1 -200;...
   0 0 0 1]
%%
H=tras*rotzz
%%
invH= inv(H)
%%
basecab= [0 0 -12 1]'
%%
baseenavi=H*basecab
%% por otro lado para el caso de la pasajera a 23 metros de los pilotos
ppas=[0 -23 0 1]' % distancia a la que está el pasajera según cabina avión
%%
pospassbase=invH*ppas
%%
