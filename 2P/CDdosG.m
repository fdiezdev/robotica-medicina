close all
clear all
clc
format bank % para que a los números chicos los muestre como cero 
l1= 0.70;
l2= 0.30;
q1 =pi/6
q2 =pi/4
X = l1*cos(q1)+l2*cos(q1+q2)
y = l1*sin(q1)+l2*sin(q1+q2)
