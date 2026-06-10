%% Ejercicios de DH
%Denavit Hartember del robot no tan elemental el primero del apunte 
close all; clear all; clc
syms q1 L p real 

format bank

q=[pi/2+q1 0] % q que es el tita en los parámetros 
d=[0 L+p] % p va desde cero a 0.3 metros 
a=[0 0]
alfa=[pi/2 0]

L= 0.7 % p va desde cero a 0.3 metros mientras que p va de cero a 0.30 metros 
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
A01

%%
A12

%%

T=A01*A12

%%

q1=pi/7; p=0.3 % p es el eslabón prismatico de cero a 0.30
eval(T)

%%


