clear all; close all; clc;
%%
pos_avion = [4000 -2000 1000 1]' 
punto_1 = [2000 0 500 1]'

%%
A01 = [1    0   0   -2000;
       0    1   0   2000;
       0    0   1   -500;
       0    0   0   1]
   
p_1 = A01 * pos_avion
%% 
gama= pi;
A12=[cos(gama) -sin(gama) 0 0;...
   sin(gama)  cos(gama)  0 0;...
   0 0 1 0;...
   0 0 0 1]
p_2 = A12 * p_1

%%
A23 = [1    0   0   2000;
       0    1   0   700;
       0    0   1   -500;
       0    0   0   1]
   
p_3 = A23 * p_2

%%

%T = A01 * A12 * A23
T = A23 * A12 * A01
%% 
p_final = T * pos_avion