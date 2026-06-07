%% MATRIZ DE TRASLACIÓN 

syms dx

close all; clear all; clc

syms dx dy dz real 
tras=[1 0 0 dx;...
   0 1 0 dy;...
   0 0 1 dz;...
   0 0 0 1]

%%  le damos a dx = 3 

dx =3, dy=2, dz=-4

tras= eval (tras)


%%
p=[1 1 1 1]'

%%
p1= tras*p

%% el origen donde está?

por=[0 0 0 1]'

%%

po= tras*por

%% EJEMPLO DE ROTACIÓN 
%roración en el eje Y
close all; clear all; clc
syms beta
beta= pi/2

roty=[cos(beta) 0 sin(beta)  0;...
   0 1 0 0;...
   -sin(beta) 0 cos(beta) 0;...
   0 0 0 1]

%%

p=[3 4 2 1]'


%%
pp = roty*p

%% DONDE ESTÁ EL ORIGEN ??

pO = roty*[0 0 0 1]'

%% COMO PODEMOS REPRESETAR PUNTOS DEL SISTEMA SUPUESTO FIJO
%EN EL SISTEMA ROTADO Y/O TRASLADADO 

syms dx

close all; clear all; clc

syms dx dy dz real 
tras=[1 0 0 dx;...
   0 1 0 dy;...
   0 0 1 dz;...
   0 0 0 1]

%%  le damoS VALORES A dx dy dz

dx =3, dy=2, dz=-4

tras= eval (tras)
%% p (0 0 3 1)

intras= inv(tras)


%%

p=[0 0 3 1]'

%%
intras*p

%% donde está el origen del sistema supuestamente fijo en el rotado/trasladado 

intras*[0 0 0 1]'


%% COMO FUNCIONA EN LAS ROTACIONES ?

%roración en el eje Y


close all; clear all; clc

syms beta

beta= pi/2

roty=[cos(beta) 0 sin(beta)  0;...
   0 1 0 0;...
   -sin(beta) 0 cos(beta) 0;...
   0 0 0 1]

%%

invroty= inv(roty)


%%

p=[0 0 3 1]'

%%

invroty*p


%% el origen donde esta?

invroty*[0 0 0 1]'

%% EJERCITACIÓN 

















%% representación de un punto en el espacio por dos sistemas de coordenadas distintos ***************
% del powerpoint de clase 
%
%
close all; clear all; clc

%ROTACIÓN EN EL EJE Z

syms gama;

gama= pi/2; % 90 GRADOS

rotz=[cos(gama) -sin(gama) 0 0;...
   sin(gama)  cos(gama)  0 0;...
   0 0 1 0;...
   0 0 0 1]

%% MATRIZ DE TRASLACIÓN 

syms dx

trax=[1 0 0 1;...
   0 1 0 2;...
   0 0 1 3;...
   0 0 0 1]

%%  

p=[1 1 1 1]'

%%


H=trax*rotz % sabemos que el producto de matrices no es conmutativo ni el concepto que representa tampoco


%%


p1=H*p

%% ¿a que distancia del origen considerado fijo se encuentra 
%  el origen del sistema rotado y trasladado?


p2=[0 0 0 1]'; % claro el origen del sistema rotado y trasladado también es un punto el (0 0 0 1)
po= trax*rotz*p2

%% a que distancia o dónde se encuentra el sistema considerado fijo "mirado" 
%   desdde el rotado y trasladado?

iversH= inv (H)

%%
po =iversH*[0 0 0 1]'








%% problema avion *************************************************************************
close all; clear all; clc


% hacerlo 


%% MATRIZ DE TRASLACIÓN 

syms dx

trax=[1 0 0 3000;...
   0 1 0 5000;...
   0 0 1 350;...
   0 0 0 1]

%%  

p=[3 5 10 1]'


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


