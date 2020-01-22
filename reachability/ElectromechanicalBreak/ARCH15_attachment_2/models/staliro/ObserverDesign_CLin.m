function [Sysbeo,L,Osys,ROsys] = ObserverDesign_CLin(Sys,poles)
%
%
%

% mb, 2007

% ... Checking observability,
%     calculation of observability matrix and its rank
Osys = obsv(Sys.A,Sys.C);
ROsys = rank(Osys);
L = [];
Sysbeo = [];

DimSys = size(Sys.A);
if DimSys(1) > ROsys,
   disp('   * Model may not be observable!                              *')
   disp('   * Numerical rank estimation of observability matrix failed. * ')
   % Achtung, der numerische 'rank'-Befehl von Matlab ist
   % nur eine Abschätzung des tatsächlichen Rangs der Matrix!
   beep
end

% ... Calculation of observer gain
L = place(Sys.A',Sys.C',poles);
% ... Calculation of observer matrices
Sysbeo.A = Sys.A - L'*Sys.C;
Sysbeo.B = [Sys.B, L'];
Sysbeo.C = eye(DimSys);
DimB = size(Sysbeo.B);
Sysbeo.D = zeros(DimSys(1),DimB(2));
   