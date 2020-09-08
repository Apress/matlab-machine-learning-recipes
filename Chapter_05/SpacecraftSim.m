%% Ship Control Demo
% Demonstrate adaptive control of a ship. We want to control the heading
% angle as the linear velocity changes. 
%% See also
% RungeKutta, RHSShip, QCR

%% Initialize
nSim      = 50;            % Number of time steps
dT        = 1;            	% Time step (sec)
dRHS      = RHSSpacecraft; 	% Get the default data structure
x         = [2.4;0.;1];       % [angle;rate;mass fuel]

%% Controller
kForward  = 0.1;
tau       = 10;

%% Simulation
xPlot     = zeros(6,nSim);
omegaOld  = x(2);
inrEst    = dRHS.i0 + dRHS.rF^2*x(3);
dRHS.tC   = 0;
tCThresh  = 0.01;
kI        = 0.99; % Inertia filter gain

for k = 1:nSim
  % Collect plotting information
  xPlot(:,k)  = [x;inrEst;dRHS.tD;dRHS.tC];
  % Control
  % Get the state space matrices
  dRHS.tC  = -inrEst*kForward*(x(1) + tau*x(2));
  omega    = x(2);
  omegaDot = (omega-omegaOld)/dT;
  if( abs(dRHS.tC) > tCThresh  )
    inrEst = kI*inrEst + (1-kI)*omegaDot/(dRHS.tC);
  end
  omegaOld = omega;  
	% Propagate (numerically integrate) the state equations
	x           = RungeKutta( @RHSSpacecraft, 0, x, dT, dRHS );
end

%% Plot the results
yL      = {'\theta (rad)' '\omega (rad/s)' 'm_f (kg)', 'I (kg-m^2)' 't_d (Nm)' 't_c (Nm)' };
pL      = {'Angle', 'Rate', 'Fuel', 'Estimated Inertia', 'Disturbance Torque', 'Control Torque'};
[t,tL]  = TimeLabel(dT*(0:(nSim-1)));

PlotSet( t, xPlot(1:3,:), 'x label', tL, 'y label', yL(1:3),...
  'plot title', pL(1:3), 'figure title', 'States' );

PlotSet( t, xPlot(4:6,:), 'x label', tL, 'y label', yL(4:6),...
  'plot title', pL(4:6), 'figure title', 'Control' );
