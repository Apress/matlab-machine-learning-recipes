%% Single neuron demonstration.
% Look at various activation functions and compare to the estimator for a
% pendulum.
%% See also
% PlotSet

%% Look at the activation functions
q       = linspace(-4,4);
v1      = tanh(q);
v2      = 2./(1+exp(-q)) - 1;

PlotSet(q,[v1;v2;q],'x label','Input', 'y label',...
  'Output', 'figure title','Activation Functions','plot title', 'Activation Functions',...
  'plot set',{[1 2 3]},'legend',{{'Tanh','Exp','Linear'}});

%% Look at the estimator for a pendulum
omega   = 1;                % pendulum frequency in rad/s
t       = linspace(0,20);
theta   = sin(omega*t);
thetaN  = 2*theta(2:end) - theta(1:end-1); % linear estimator for "next" theta
truth   = theta(3:end);
tOut    = t(3:end);
thetaN  = thetaN(1:end-1);

% Apply the activation function
z = tanh(thetaN);

PlotSet(tOut,[truth;thetaN;z],'x label','Time (s)', 'y label',...
  'Next angle', 'figure title','One neuron','plot title', 'One neuron',...
  'plot set',{[1 2 3]},'legend',{{'True','Estimate','Neuron'}});