%%%%Initializations for meshing model of Motor-Transmission Drive System%%%
%This file includes configuration parameters, initial states, inputs and 
%disturbances of Motor-Transmission Drive System. 
%For model checking, user could change the initial states and disturbances
%with reference to their pre-defined domains.
%Author: Hongxu Chen
%E-mail:herschel.chen@gmail.com
%Date:20160102
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Configuration Parameters
zeta = 0.9; %coefficient of restitution
ms = 3.2; %mass of sleeve(kg)
mg2 = 18.1; %mass of second gear(kg)
Jg2 = 0.7; %inertia of second gear(kg*m^2)
ig2 = 3.704; %gear ratio of second gear
Rs = 0.08; %radius of sleeve(m)
theta = pi*(36/180); %included angle of gear(rad)
b = 0.01; %width of gear spline(m)
deltap = -0.003; %axial position where sleeve engages with second gear(m)

%Inital states
vx0 = 0; %Initial velocity of sleeve along x axis(m/s)
vy0 = 0; %Initial velocity of sleeve along y axis(m/s),its domain is: [-1*Rs, 1*Rs]
px0 = -0.0165; %Initial position of sleeve along x axis(m)
py0 = 0.003; %Initial position of sleeve along y axis(m),its domain is: [-b,b]
I0 = 0; %Impact impulse(kg*m/s)

%Model inputs
Fs = 70; %shifting force(N)

%Disturbances
Tf = 1; %resisting moment(N*m), its domain is [1,5]
