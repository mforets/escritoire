% EMB closed-loop model
% Nomial behaviour
% Requirement 2: Small Impulse

clear;

model = 'EMB';
load('EMB_Variables.mat');

init_cond = [];

disp('The constraints on the input signal defined as a range:')
input_range = [0 0; R R; L L]
disp(' ')
disp('The number of control points for the input signal:')
cp_array = [1 1 1]

disp(' ')
disp('The specification:')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we want to falsify the negation of the requirement
% because the system actually satisfies this formula
% but not very robustly so
phi = '!( []((r12 /\ X r11) -> r2) )'

clear preds;

% x >= x0
ii = 1;
preds(ii).str='r11';
preds(ii).A = [-1 0 0 0 0];
preds(ii).b = -x0;
preds(ii).loc = [];

% x <= x0
ii = ii+1;
preds(ii).str='r12';
preds(ii).A = [1 0 0 0 0];
preds(ii).b = x0;
preds(ii).loc = [];

% v <= 2mm/s
ii = ii+1;
preds(ii).str='r2';
preds(ii).A = [0 1 0 0 0];
preds(ii).b = 0.2;
preds(ii).loc = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
disp('Total Simulation time:')
time = 0.05

opt = staliro_options();
opt.runs = 1;       % need only one run, because system is deterministic
n_tests = 1000;
opt.interpolationtype={'const', 'const', 'const'};

opt.optimization_solver = 'UR_Taliro';

disp(' ')
disp('Running S-TaLiRo with chosen solver ...')
tic
results = staliro(model,init_cond,input_range,cp_array,phi,preds,time,opt);
runtime=toc;

runtime

results.run(results.optRobIndex).bestRob

[T1,XT1,YT1,IT1] = SimSimulinkMdl(model,init_cond,input_range,cp_array,results.run(results.optRobIndex).bestSample(:,1),time,opt);

figure
set(0, 'DefaultAxesFontSize', 16)
set(0, 'DefaultTextFontSize', 16)

[ax,p1,p2] = plotyy(T1, YT1(:,1), T1, YT1(:,2), 'plot', 'plot');
xlabel('t')
ylabel(ax(1), 'x')
ylabel(ax(2), 'v')
hold on
plot([0 time],[x0 x0],'r');
