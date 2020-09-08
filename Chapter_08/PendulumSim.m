%% Pendulum simulation
% Demonstrate a pendulum with either linear or nonlinear dynamics.
%
%% See also
% RungeKutta, RHSPendulum

%% Initialize the simulation
n             = 1000;         % Number of time steps
dT            = 0.1;          % Time step (sec)
dRHS          = RHSPendulum;	% Get the default data structure
dRHS.linear   = false;        % true for linear model

%% Simulation
xPlot         = zeros(2,n);
theta0        = 3;           % radians
x             = [theta0;0];  % [angle;velocity]

for k = 1:n
  xPlot(:,k)  = x;
  x           = RungeKutta( @RHSPendulum, 0, x, dT, dRHS );
end

%% Plot the results
yL      = {'\theta (rad)' '\omega (rad/s)'};
[t,tL]  = TimeLabel(dT*(0:n-1));

PlotSet( t, xPlot, 'x label', tL, 'y label', yL, ...
        'plot title', 'Pendulum', 'figure title', 'Pendulum State' );
