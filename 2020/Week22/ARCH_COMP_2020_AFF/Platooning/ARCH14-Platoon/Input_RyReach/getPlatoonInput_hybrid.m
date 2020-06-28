function [states,q,qa,transitions,I,U,configuration] = getPlatoonInput111311 
% Platoon11-13-11

        % definition of locations -----------------------------------------
        % continuous dynamics in each state    
        states{1}.A = [
        0    1.0000         0         0         0         0         0         0         0;...
        0         0   -1.0000         0         0         0         0         0         0;...
        1.6050    4.8680   -3.5754   -0.8198    0.4270   -0.0450   -0.1942    0.3626   -0.0946;...
        0         0         0         0    1.0000         0         0         0         0;...
        0         0    1.0000         0         0   -1.0000         0         0         0;...
        0.8718    3.8140   -0.0754    1.1936    3.6258   -3.2396   -0.5950    0.1294   -0.0796;...
        0         0         0         0         0         0         0    1.0000         0;...
        0         0         0         0         0    1.0000         0         0   -1.0000;...
        0.7132    3.5730   -0.0964    0.8472    3.2568   -0.0876    1.2726    3.0720   -3.1356 ]; 
        states{1}.B = [0 ;1; 0; 0; 0; 0; 0; 0; 0 ];
    
        states{2}.A = [
        0    1.0000         0         0         0         0         0         0         0;...
        0         0   -1.0000         0         0         0         0         0         0;...
        1.6050    4.8680   -3.5754         0         0         0         0         0         0;...
        0         0         0         0    1.0000         0         0         0         0;...
        0         0    1.0000         0         0   -1.0000         0         0         0;...
        0         0         0    1.1936    3.6258   -3.2396         0         0         0;...
        0         0         0         0         0         0         0    1.0000         0;...
        0         0         0         0         0    1.0000         0         0   -1.0000;...
        0.7132    3.5730   -0.0964    0.8472    3.2568   -0.0876    1.2726    3.0720   -3.1356 ];
        states{2}.B = [0 ;1; 0; 0; 0; 0; 0; 0; 0 ];
        
        q=[1 2]; % discrete states
        qa = 1; % initial location
        
        % definition of transitions ---------------------------------------
        % transition 1 is spontaneous
        transitions{1}.spontaneous = true;
        transitions{1}.timeelapse = 20; % after 20 time units
        % start and end location of the transition nbr 1
        transitions{1}.from = 1;
        transitions{1}.to = 2;
        
        % transition 2 is spontaneous
        transitions{2}.spontaneous = true;
        transitions{2}.timeelapse = 40; % after 40 time units
        % start and end location of the transition nbr 2
        transitions{2}.from = 2;
        transitions{2}.to = 1;
      
        % initial values --------------------------------------------------
        % initial set (as polyheder)
        I.polyheder.C = vectorgenerator(9) ;
        I.polyheder.d = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
        
        % input set (as polyheder)
        U.polyheder.C = vectorgenerator(1);
        U.polyheder.d = [1; 9];
        
        % configuration parameters ----------------------------------------
        configuration.timehorizon = 22; % time horizon
        configuration.timestep = 0.01; % timestep