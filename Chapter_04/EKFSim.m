%% EKFSIM Demonstrate an Extended Kalman Filter. 
% The model is an oscillator. The measurement is the angle between the line of
% sight from a sensor and the horizon. This measurement is nonlinear. The EKF
% can handle nonlinear measurements directly. The dynamical model is linear.
%
%% See also
% RungeKutta, RHSOscillator, RHSOscillatorPartial, KFInitialize, EKFUpdate,
% EKFPredict, AngleMeasurement, AngleMeasurementPartial, TimeLabel, PlotSet


%% Initialize
nSim            = 5000;             % Simulation steps
dT              = 0.1;              % Time step (sec)
d               = RHSOscillator();  % Get the default data structure
d.a             = 0.1;              % Disturbance acceleration
d.zeta          = 0.1;              % Damping ratio
x               = [0;0];            % Initial state [position;velocity]
y1Sigma         = 0.01;             % 1 sigma measurement noise
dMeas.baseline  = 10;               % Distance of sensor from start
xE              = [0;0];            % Estimated initial state
q               = diag([0.01 0.001]);
p               = diag([0.001 0.0001]);
dKF             = KFInitialize( 'ekf','m',xE,'f',@RHSOscillator,'fX',...
                                @RHSOscillatorPartial,'fData',d,...
                                'r',y1Sigma^2,'q',q,'p',p,...
                                'h',@AngleMeasurement,'hData',dMeas,...
                                'hX',@AngleMeasurementPartial,'dT', dT);

%% Simulation
xPlot = zeros(5,nSim);

for k = 1:nSim
  % Angle measurement with random noise
  y = AngleMeasurement( x, dMeas ) + y1Sigma*randn;
  
  % Update the Kalman Filter
  dKF.y = y;
  dKF   = EKFUpdate(dKF);
  
  % Plot storage
  xPlot(:,k) = [x;y;dKF.m-x];
  
  % Propagate (numerically integrate) the state equations
  x = RungeKutta( @RHSOscillator, 0, x, dT, d ); 
  
  % Propagate the Kalman Filter
  dKF = EKFPredict(dKF);
end

%% Plot the results
yL     = {'r (m)' 'v (m/s)'  'y (rad)' '\Delta r_E (m)' '\Delta v_E (m/s)' };
[t,tL] = TimeLabel(dT*(0:(nSim-1)));

PlotSet( t, xPlot, 'x label', tL, 'y label', yL,...
  'plot title', 'EKF Simulation', 'figure title', 'EKF Simulation' );
