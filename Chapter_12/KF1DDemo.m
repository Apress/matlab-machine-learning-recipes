%% One dimensional Kalman Filter demo.
% One dimensional Kalman test with two vehicles with random accelerations.
%
% The vehicles also have a steady acceleration. The vehicles start a
% distance apart determined by a uniform random number between 0 and 1.
%
% The plant model has a position, velocity and acceleration state. The
% measurement is the position of each vehicle, with noise.
%
% The demo uses the Kalman Filter (KF). It takes only a few seconds.
%
%% See also:
% DoubleIntegratorWithAccel, KFInitialize, KFPredict, KFUpdate

%% Initialize

% Set the seed for the random number generators. 
% If the seed is not set each run will be different.
seed = 45198;
rng(seed);

% Parameters
n       = 180;              % Number of steps
r0      = 1e-2;             % Measurement 1-sigma
dT      = 0.5;              % The time step
aRand   = 0.0001;           % Random acceleration 1-sigma
q0      = [0.02;0.2;0.04];  % The baseline plant covariance diagonal
p0      = [0.2;0.9;1];      % Initial state covariance matrix diagonal

% Initial state vector [s1;v1;a1;s2;v2;a2]
x0      = [20;0;0;0;0;0.01];   

% The time vector
t       = dT*(0:n-1);

% The state transition matrices for the Kalman Filter
[a, b]  = DoubleIntegratorWithAccel( dT );

% The acceleration input vector
u       = zeros(2,n);

%% Propagate the state vector
x       = zeros(6,n);
x(:,1)  = x0;

for k = 1:n-1
    x(:,k+1) = [a*x(1:3,k) + b*u(1,k);...
                a*x(4:6,k) + b*u(2,k)];
end

% Measurements
r       = r0^2*eye(2);
h       = [1 0 0 0 0 0;0 0 0 1 0 0];
z       = h*x + r0*randn(2,n);

%% Run the Kalman Filter
% The covariances
r    	= r(1,1);
q   	= diag([0.5*aRand*dT^2;aRand*dT;aRand].^2 + q0);

% Create the Kalman Filter data structures
d1    = KFInitialize( 'kf', 'm', [0;0;0],  'x', [0;0;0], 'a', a, 'b', b, 'u',0,...
                      'h', h(1,1:3), 'p', diag(p0), 'q', q, 'r', r );
d2    = d1;
d1.m	= x(1:3,1) + sqrt(p0).*rand(3,1);
d2.m	= x(4:6,1) + sqrt(p0).*rand(3,1);
xE    = zeros(6,n);

for k = 1:n
  d1      = KFPredict( d1 );
  d1.y    = z(1,k);
  d1      = KFUpdate( d1 );
  
  d2      = KFPredict( d2 );
  d2.y    = z(2,k);
  d2      = KFUpdate( d2 );
  
  xE(:,k) = [d1.m;d2.m];
end
                          
%% Plot the results
[t, tL]	= TimeLabel(t);
PlotSet(t,x,'x label',tL,'y label', {'s' 'v' 'a' },'figure title','States for Vehicles','plot set',...
        {[1 4] [2 5] [3 6]},'legend',{{'1' '2'} {'1' '2'} {'1' '2'}});

yL      = {'\delta s' '\delta v' '\delta a'};
PlotSet(t,xE - x,'x label',tL,'y label',yL,'figure title','Estimator Errors',...
        'plot set',{[1 4],[2 5],[3 6]},'legend',{{'1' '2'} {'1' '2'} {'1' '2'}});  

