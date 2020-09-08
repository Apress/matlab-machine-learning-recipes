%% Pendulum angle predictor
% Builds, trains and tests a Neural Net to predict the next angle
% of a pendulum based on its previous two angles. 
% The Neural Net has one hidden layer with three nodes.
%
%% See also
% RungeKutta, PlotSet, NeuralNetTraining, NeuralNetMLFF, Neuron

% Demo parameters
nSamples    = 800;        % Samples in the simulation
nRuns       = 2000;       % Number of training runs
activation  = 'tanh';     % activation function

omega       = 0.5;        % frequency in rad/s
tau         = 2*pi/omega; % period in secs
dT          = tau/100;    % sample at a rate of 20*omega

rng(100);           % consistent random number generator

%% Initialize the simulation RHS
dRHS        = RHSPendulum; % Get the default data structure
dRHS.linear = false;
dRHS.omega  = omega;

%% Simulation
nSim   = nSamples + 2;
x      = zeros(2,nSim);
theta0 = 0.1;             % starting position (angle)
x(:,1) = [theta0;0];       
for k = 1:nSim-1
  x(:,k+1) = RungeKutta( @RHSPendulum, 0, x(:,k), dT, dRHS );
end

%% Plot the results of the simulation
yL      = {'\theta (rad)' '\omega (rad/s)'};
[t,tL]  = TimeLabel(dT*(0:nSim-1));

PlotSet( t, x, 'x label', tL, 'y label', yL, ...
        'plot title', 'Pendulum', 'figure title', 'Pendulum State' );

%% Define a network with two inputs, three inner nodes, and one output
layer            = struct;
layer(1,1).type  = activation;
layer(1,1).alpha = 1;
layer(2,1).type  = 'sum'; %'sum';
layer(2,1).alpha = 1;

% Thresholds
layer(1,1).w0 = rand(3,1) - 0.5;
layer(2,1).w0 = rand(1,1) - 0.5;

% Weights w(i,j) from jth input to ith node
layer(1,1).w  = rand(3,2) - 0.5;
layer(2,1).w  = rand(1,3) - 0.5;

%% Train the network
% Order the samples using a random list
kR          = ceil(rand(1,nRuns)*nSamples);
thetaE      = x(1,kR+2); % Angle to estimate
theta       = [x(1,kR);x(1,kR+1)]; % Previous two angles
e           = thetaE - (2*theta(1,:) - theta(2,:));
[w,e,layer] = NeuralNetTraining( theta, thetaE, layer );

PlotSet(1:length(e), e.^2, 'x label','Sample', 'y label','Error^2',...
  'figure title','Training Error','plot title','Training Error','plot type','ylog');

% Assemble a new network with the computed weights
layerNew            = struct;
layerNew(1,1).type  = layer(1,1).type;
layerNew(1,1).w     = w(1).w;
layerNew(1,1).w0    = w(1).w0;
layerNew(2,1).type  = layer(2,1).type; %'sum';
layerNew(2,1).w     = w(2).w;
layerNew(2,1).w0    = w(2).w0;
network.layer       = layerNew;

%% Simulate the pendulum with a different starting point
x(:,1)        = [0.1;0];

%% Simulate the pendulum and test the trained network
% Choose the same or a different starting point and simulate
thetaD = 0.5;         
x(:,1) = [thetaD;0];
for k = 1:nSim-1
  x(:,k+1) = RungeKutta( @RHSPendulum, 0, x(:,k), dT, dRHS );
end

% Test the new network
theta 	= [x(1,1:end-2);x(1,2:end-1)];
thetaE	= NeuralNetMLFF( theta, network );
eTSq    = (x(1,3:end)-thetaE).^2;

PlotSet(1:length(eTSq), eTSq, 'x label','Test', 'y label','Error^2',...
  'figure title','Testing Error','plot title','Testing Error','plot type','ylog');

PlotSet(1:length(thetaE), [thetaE;x(1,3:end)], 'x label','Sample', 'y label','Next Angle',...
  'figure title','Angles','plot title','Angles','legend',{{'Estimate','True'}},'plot set',{[1 2]});

