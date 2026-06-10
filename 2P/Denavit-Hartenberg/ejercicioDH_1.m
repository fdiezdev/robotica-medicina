%% Ejercicios de DH
%Denavit Hartember_ejer.doc   de dos grados de libertad pantografo
close all; clear all; clc
syms q1 q2 real 

% Parámetros de DH del archivo de word
q=[q1 q2]
d=[0 0]
a=[3 1.5]
alfa=[0 0]

%%

i=1;
A01=[cos(q(i)) -cos(alfa(i))*sin(q(i))  sin(alfa(i))*sin(q(i)) a(i)*cos(q(i));...
   sin(q(i))  cos(alfa(i))*cos(q(i)) -sin(alfa(i))*cos(q(i)) a(i)*sin(q(i));...
   0          sin(alfa(i))            cos(alfa(i))           d(i);...
   0 0 0 1]
%%

i=2;
A12=[cos(q(i)) -cos(alfa(i))*sin(q(i))  sin(alfa(i))*sin(q(i)) a(i)*cos(q(i));...
   sin(q(i))  cos(alfa(i))*cos(q(i)) -sin(alfa(i))*cos(q(i)) a(i)*sin(q(i));...
   0          sin(alfa(i))            cos(alfa(i))           d(i);...
   0 0 0 1]

%%

T=A01*A12

%%

q1=pi;q2=-pi/2
eval(T)




