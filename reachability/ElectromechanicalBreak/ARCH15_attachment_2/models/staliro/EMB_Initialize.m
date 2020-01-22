clc
clear all
close all
disp(' '); disp(' ******* Initialization of Simulink-Model for EMB-Example No. 1 ******* ')
disp(' Modeling and parameterization ... ')
R       = 0.5;
K       = 0.02;
L       = 1e-3;
Ubrush  = 0.0;
J       = 1e-5;
d_rot   = 0.1;
m       = 0.1;
d_trans = 0.1;
c_gear  = 2e+5;
r2      = 0.05;
alpha   = 0.175;
i       = 1/(r2*tan(alpha));
c_break = 1e6;
x0      = 0.05;
t0      = 0.1;
t1      = 2.5e-3;
x_break = 0.0005;
T_abtast = 100e-6;
A = [-R/L -K/L       0              0          0;
      K/J -d_rot/J  -c_gear/(J*i)   0          c_gear/J;
      0    1         0              0          0;
      0    0         c_gear/m      -d_trans/m -i*c_gear/m;
      0    0         0              1          0];
A2 = [-R/L -K/L       0              0          0;
       K/J -d_rot/J  -c_gear/(J*i) 0            c_gear/J;
       0    1         0              0          0;
       0    0         c_gear/m      -d_trans/m -i*c_gear/m - c_break/m;
       0    0         0              1          0];
B     = [1/L 0 0  0   0]';
B2    = [1/L 0 0 0 0;
         0   0 0 c_break/m 0]';
B_Sim = [1/L 0 0 0   0;
         0   0 0 1/m 0]';
C = [0 0 0 0 1];
C2 = [0 0 0 0 1];
C_Sim = eye(5);
D = [0];
D2 = [0 0];
D_Sim = [0 0 0 0 0;
         0 0 0 0 0]';
Ared1 = [-(R/L+K^2/(L*d_rot))  K*c_gear/L/d_rot/i -K*c_gear/L/d_rot;
         K/d_rot              -c_gear/d_rot/i      c_gear/d_rot;
         0                     c_gear/d_trans     -i*c_gear/d_trans];
Bred1 = [1/L 0 0;
         0   0 1/d_trans]';
Cred1 = eye(3);
Dred1 = zeros(3,2);
a1help2 = -(R/L+K^2/(L*d_rot));
a2help2 = K/d_rot/i;
Ared2 = [a1help2 0;
         a2help2 0];
Bred2 = [1/L 0;
         0   0];
Cred2 = [1 0; 0 1];
Dred2 = zeros(2,2);
a1help3 = L*c_gear/(L*c_gear + K^2*i);
a2help3 = -(R/L + K^2*i^2/L/d_trans);
a3help3 = K*i/L/d_trans;
a4help3 = K*i/d_trans;
Ared3 = [a1help3*a2help3 0;
         a4help3         0];
Bred3 = [a1help3*1/L -a1help3*a3help3;
         0            1/d_trans];
Cred3 = eye(2);
Dred3 = zeros(2,2);
a1help4 = K/(R/L*d_rot + K^2/(L*d_rot));
a2help4 = K/L*c_gear/d_rot;
a3help4 = c_gear/d_rot;
Ared4 = [(-a3help4 + a1help4*a2help4/i)  (-a1help4*a2help4 + a3help4);
         c_gear/d_trans                 -i*c_gear/d_trans];
Bred4 = [a1help4/L 0;
         0         1/d_trans];
Cred4 = eye(2);
Dred4 = zeros(2,2);
disp(' ... modeling done! ')
disp(' Feedforward control ... ')
sys_zf = ss(A,B,C,D);
sys_tf  = tf(sys_zf);
[num,den] = tfdata(sys_tf); 
a = den{1};
b = num{1}(6);
disp(' ... feedforward control done! ')
disp( ' Observer design ... ')
disp(' ... identity observer ')
A_BeoEntwurf = A; 
B_BeoEntwurf = B_Sim(:,1);  
C_BeoMess = [1 0 0 0 0;
             0 1 0 0 0;
             0 0 1 0 0];       
lambda = [-1200 -1700 -2000 -2800 -2900];
SysBeoEntwurf.A = A_BeoEntwurf;
SysBeoEntwurf.B = B_BeoEntwurf;
SysBeoEntwurf.C = C_BeoMess;
[SysBeobachter,L_Beo,OB,rkOB] = ObserverDesign_CLin(SysBeoEntwurf,lambda);
lambda = [-1200 -15000 -8000 -25000 -30000];
L_B1h = place(A_BeoEntwurf(1,1),1,lambda(1,1));
L_B2h = place(A_BeoEntwurf(2:5,2:5)',C_BeoMess(3,2:5)',lambda(2:5));
L_Beo = [L_B1h,zeros(1,4);zeros(1,5);0,L_B2h];
A_Beo1 = A_BeoEntwurf - L_Beo'*C_BeoMess;
B_Beo1 = [B_BeoEntwurf, L_Beo'];
C_Beo1 = eye(size(A_Beo1));
[a1 b1] = size(C_Beo1);
[c1 d1] = size(B_Beo1);
D_Beo1 = zeros(a1,d1);
x0_Beo1 = zeros(5,1);
disp(' ... reduced order observer for case 1 ')
SysBeoEntwurf_red2_1a.A = Ared2;
SysBeoEntwurf_red2_1a.B = Bred2(:,1);
SysBeoEntwurf_red2_1a.C = Cred2;
lambda_red2_1a = [-600 -700];
[SysBeoRed2,Lred2,OBred2,rkOBred2] = ObserverDesign_CLin(SysBeoEntwurf_red2_1a,lambda_red2_1a);
SysBeoEntwurf_red2_1b.A = Ared2(1,1);
SysBeoEntwurf_red2_1b.B = Bred2(1,1);
SysBeoEntwurf_red2_1b.C = 1;
lambda_red2_1b = -600;
[SysBeoRed2_1b,Lred2_1b,OBred2_1b,rkOBred2_1b] = ObserverDesign_CLin(SysBeoEntwurf_red2_1b,lambda_red2_1b);
SysBeoRed2_1b.A = [SysBeoRed2_1b.A 0; Ared2(2,:)];
SysBeoRed2_1b.B = [SysBeoRed2_1b.B; zeros(1,2)];
SysBeoRed2_1b.C = eye(2);
disp(' ... reduced order observer for case 2 ')
SysBeoEntwRed3apV1.A = [a1help3*a2help3  a1help3*a3help3*c_break; 
                        a4help3         -c_break/d_trans];
SysBeoEntwRed3apV1.B = Bred3(:,1);
SysBeoEntwRed3apV1.C = [1 0];
lambda_red3 = [-3e7 -1e7];
[SysBeoRed3apV1,LRed3apV1,OBRed3apV1,rkOBRed3V1] = ObserverDesign_CLin(SysBeoEntwRed3apV1,lambda_red3);
SysBeoEntwRed3apV2.A = SysBeoEntwRed3apV1.A;
SysBeoEntwRed3apV2.B = SysBeoEntwRed3apV1.B; 
SysBeoEntwRed3apV2.C = eye(2);
lambda_red3 = [-3e7 -4e7];
[SysBeoRed3apV2,LRed3apV2,OBRed3apV2,rkOBRed3V2] = ObserverDesign_CLin(SysBeoEntwRed3apV2,lambda_red3);
disp(' ... observer done! ')
disp(' Feedback control ... ')
P_Pos   = 10000;
I_Pos   = 1000;
D_Pos   = 0;
P_Kraft = P_Pos; 
I_Kraft = I_Pos; 
D_Kraft = D_Pos; 
disp(' ... feedback control done! ')
save EMB_Variables
disp(' ******* DONE! ************************************************************** ')
