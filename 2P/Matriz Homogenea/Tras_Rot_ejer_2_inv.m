%% MATRIZ DE TRASLACIÓN 

syms dx

close all; clear all; clc

syms dx dy dz real 
tras=[1 0 0 dx;...
   0 1 0 0;...
   0 0 1 0;...
   0 0 0 1]

%%  le damos a dx = 3 

dx =3

eval (tras)

%% si ahora definimos Tras1

tras1=[1 0 0 1;...
   0 1 0 -6;...
   0 0 1 -7;...
   0 0 0 1]

%%
p=[2 3 4 1]'

p1= tras1*p

%% matrices de rotación

close all; clear all; clc

%ROTACIÓN EN EL EJE Z

syms gama
rotz=[cos(gama) -sin(gama) 0 0;...
   sin(gama)  cos(gama)  0 0;...
   0 0 1 0;...
   0 0 0 1]
%%
gama= pi/2 % 90 GRADOS

rotzz =eval (rotz)
%%
p=[3 0 0 1]'


pp = rotzz*p

%%
close all; clear all; clc

gama= -pi/2;

rotz=[cos(gama) -sin(gama) 0 0;...
   sin(gama)  cos(gama)  0 0;...
   0 0 1 0;...
   0 0 0 1]
%%

p=[3 0 0 1]'

pp = rotz*p


%% rotación en X

close all; clear all; clc

syms alfa

%%
alfa= pi
    
rotx=[1 0 0 0;...
   0 cos(alfa) -sin(alfa) 0;...
   0 sin(alfa) cos(alfa) 0;...
   0 0 0 1]

%%

p=[0 0 3 1]'

pp = rotx*p





%% roración en el eje Y


close all; clear all; clc

syms beta

beta= pi/2

roty=[cos(beta) 0 sin(beta)  0;...
   0 1 0 0;...
   -sin(beta) 0 cos(beta) 0;...
   0 0 0 1]

%%

p=[3 0 0 1]'

pp = roty*p



%% EJERCITACIÓN y matríz inversa
% ver matriz_inversa.pptx que es el powerpoint de clase 
% 

close all; clear all; clc

tras1=[1 0 0 -3;...
   0 1 0 0;...
   0 0 1 -3;...
   0 0 0 1]

%%
p=[3 0 0 1]'

p1= tras1*p

%% inversa de una matriz la setencia inv() calcula la inversa de una matriz 

Hi=inv(tras1)

%%
Hi*[0 0 -3 1]' % ahora verificamos si la inversa nos lleva al punto de origen


%% como colocar el punto p( 3,0,0) en p'(0,0,-3) con dos rotaciones explicado en clase 

close all; clear all; clc

%ROTACIÓN EN EL EJE Z

syms gama
rotz=[cos(gama) -sin(gama) 0 0;...
   sin(gama)  cos(gama)  0 0;...
   0 0 1 0;...
   0 0 0 1]
%%
gama= pi/2 % 90 GRADOS

rotzz =eval (rotz)
%%
p=[3 0 0 1]'

%%

pp = rotzz*p


%%

syms alfa


alfa= -pi/2
    
rotx=[1 0 0 0;...
   0 cos(alfa) -sin(alfa) 0;...
   0 sin(alfa) cos(alfa) 0;...
   0 0 0 1]

%%

p=[0 3 0 1]'

%%

ppp = rotx*p


%% puedo hacer la combinación en un solo paso ?



RT= rotx*rotzz

%%

ppp= rotx*rotzz*[3 0 0 1]'

%%

RT

%%

RT*[3 0 0 1]'


%% inverso 

TR= inv(RT)

%%
TR*[0 0 -3 1]'




%% El punto p ( 1,1,0,1) se la aplicarán las siguientes rotaciones en el siguiente orden:
% primero rotar al punto pp= ( rot y, +pi/2)* p
% segundo rotar ppp= (rot x, -pi/2)*pp
% tercero rotar pppp= (rot z, 3*2/pi) ppp 




close all; clear all; clc

P=[1 1 0 1]

%%

syms beta

beta= pi/2

roty=[cos(beta) 0 sin(beta)  0;...
   0 1 0 0;...
   -sin(beta) 0 cos(beta) 0;...
   0 0 0 1]

%%

pp = roty*P'



%% segundo rotar ppp= (rot x, -pi/2)*pp

syms alfa

alfa= -pi/2
    
rotx=[1 0 0 0;...
   0 cos(alfa) -sin(alfa) 0;...
   0 sin(alfa) cos(alfa) 0;...
   0 0 0 1]

%%

ppp = rotx*[0 1 -1 1]'

%% tercero rotar pppp= (rot z, 3*2/pi) ppp 

%ROTACIÓN EN EL EJE Z

syms gama
rotz=[cos(gama) -sin(gama) 0 0;...
   sin(gama)  cos(gama)  0 0;...
   0 0 1 0;...
   0 0 0 1]
%%
gama= 3/2*pi 

rotzz =eval (rotz)
%%



pppp = rotzz*ppp

%%
% primero rotar al punto pp= ( rot y, +pi/2)* p
% segundo rotar ppp= (rot x, -pi/2)*pp
% tercero rotar pppp= (rot z, 3*2/pi) ppp 


ppver= rotzz*rotx*roty*[1 1 0 1]'

% puedo hacerlo por partes 

%%




syms gama

gama= pi/2

rotz=[cos(gama) -sin(gama) 0 0;...
   sin(gama)  cos(gama)  0 0;...
   0 0 1 0;...
   0 0 0 1]



%%

syms dx

dx=3

trax=[0 0 0 dx;...
   0 0 0 0;...
   0 0 0 0;...
   0 0 0 1]

rotz*trax


p=[0 0 1 1]'


rotz*trax*p
%% Clase 7 

%ROTACIÓN EN EL EJE Z

syms gama

gama= pi/2 % 90 GRADOS

rotz=[cos(gama) -sin(gama) 0 0;...
   sin(gama)  cos(gama)  0 0;...
   0 0 1 0;...
   0 0 0 1]

%%

p=[3 0 0 1]'


%%
pp = rotz*p

%%

%rotación en X



syms alfa

alfa= pi/2

rotx=[1 0 0 0;...
   0 cos(alfa) -sin(alfa) 0;...
   0 sin(alfa) cos(alfa) 0;...
   0 0 0 1]

%%

p=[0 3 0 1]'

pp = rotx*p



%% las dos rtaciones juntas son:

p=[3 0 0 1]'
PP=rotx*rotz*p

%%

Rott=rotx*rotz

%%

p=[3 0 0 1]'

pp=Rott*p

%%


syms beta

beta= pi/2

roty=[cos(beta) 0 sin(beta)  0;...
   0 1 0 0;...
   -sin(beta) 0 cos(beta) 0;...
   0 0 0 1]


p= roty*[0 0 3 1]'
%%

%ROTACIÓN EN EL EJE Z nuevamente **************************

syms gama

gama= pi/2 % 90 GRADOS

rotz=[cos(gama) -sin(gama) 0 0;...
   sin(gama)  cos(gama)  0 0;...
   0 0 1 0;...
   0 0 0 1]

%%

p=[3 0 0 1]'

%%
PX=rotz*p

%%

inv(rotz)*[0 3 0 1]' % volvemos al punto inicial con la inversa de rotz

%%

rotz*inv(rotz)  % tendría que dar la matriz identidad de 4x4


