function [states,q,qa,transitions,I,U,configuration] = getPlatoon11Input
% Platoon11

        % definition of locations -----------------------------------------
        % continuous dynamics in each state        
        states{1}.A = [0    1.0000         0         0         0         0         0         0         0;...
        0         0   -1.0000         0         0         0         0         0         0;...
        1.6050    4.8680   -3.5754   -0.8198    0.4270   -0.0450   -0.1942    0.3626   -0.0946;...
        0         0         0         0    1.0000         0         0         0         0;...
        0         0    1.0000         0         0   -1.0000         0         0         0;...
        0.8718    3.8140   -0.0754    1.1936    3.6258   -3.2396   -0.5950    0.1294   -0.0796;...
        0         0         0         0         0         0         0    1.0000         0;...
        0         0         0         0         0    1.0000         0         0   -1.0000;...
        0.7132    3.5730   -0.0964    0.8472    3.2568   -0.0876    1.2726    3.0720   -3.1356 ];  
 
        states{1}.B = [0 ;1; 0; 0; 0; 0; 0; 0; 0 ];
        
        q=[1]; % discrete states 
        qa=1; % initial mode
        
        % definition of transitions ---------------------------------------
        transitions = []; % no transitions
        
        % initial values --------------------------------------------------
        % initial set (as polyheder)
        I.polyheder.C = vectorgenerator(9) ;
        I.polyheder.d = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];

        % input set (as polyheder)
        U.polyheder.C = vectorgenerator(1);
        U.polyheder.d = [1; 9];
        
        % configuration parameters ----------------------------------------
        configuration.timehorizon = 20; % time horizon
        configuration.timestep = 0.01; % timestep
        
       
        
        
     