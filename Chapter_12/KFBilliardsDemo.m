%% Billiard demo using a Kalman filter to estimate the ball states.
%
% This models billiard balls that can bounce off the walls of an 
% enclosure. The model is two double integrators but because of the 
% bounce there is considerable model uncertainty in position and
% velocity. The sensor outputs the x and y position of each ball
% with noise.
%
% The state vector is [x;vX;y;vY].
%
% The demo uses the Kalman Filter (KF). 
%
% The simulation is run first and then the KF estimates the trajectory
% of the balls. The demo also computes the MHT distance for the
% balls. You can select the number of balls.
%   
%% See also BilliardCollision, RHSBilliards
%%

%% Initialize

% Set the seed for the random number generators. 
% If the seed is not set each run will be different.
seed = 45198;
rng(seed);

% Time step setup
dT   = 0.1; % sec
tEnd = 8; % sec

% The number of balls and the random initial position and velocity
d       = struct('nBalls',3,'xLim',[-1 1], 'yLim', [-1 1]);
sigP    = 0.4; % 1 sigma noise for the position
sigV    = 1; % 1 sigma noise for the velocity
sigMeas = 0.00000001; % 1 sigma noise for the measurement

% Set the initial state for  2 sets of position and velocity
x  = zeros(4*d.nBalls,1);
rN = rand(4*d.nBalls,1);

for k = 1:d.nBalls
  j        = 4*k-3;
  x(j  ,1) = sigP*(rN(j  ) - 0.5);
  x(j+1,1) = sigV*(rN(j+1) - 0.5);
  x(j+2,1) = sigP*(rN(j+2) - 0.5);
  x(j+3,1) = sigV*(rN(j+3) - 0.5);
end

% For initializing the Kalman Filter
x0 = x;

% Set the number of time steps
n = ceil(tEnd/dT);

% Plotting
xP = zeros(length(x),n);

%% Simulate

% Sensor measurements
nM	= 2*d.nBalls;
y   = zeros(nM,n);
iY  = zeros(nM,1);

for k = 1:d.nBalls
  j = 2*k-1;
  iY(j  )	= 4*k-3;
  iY(j+1)	= 4*k-1;
end

for k = 1:n
  
  % Collisions
  x = BilliardCollision( x, d );
  
  % Plotting
  xP(:,k)	= x;
  
  % Integrate using a 4th Order Runge-Kutta integrator
  x = RungeKutta(@RHSBilliards, 0, x, dT, d );
  
  % Measurements with Gaussian random noise
  y(:,k) = x(iY) + sigMeas*randn(nM,1);
  
end

% Plot the simulation results
NewFigure( 'Billiard Balls' )
c  = 'bgrcmyk';
kX = 1;
kY = 3;
s  = cell(1,d.nBalls);
l = [];
for k = 1:d.nBalls
  plot(xP(kX,1),xP(kY,1),['o',c(k)])
  hold on
  l(k)	= plot(xP(kX,:),xP(kY,:),c(k));
  kX    = kX + 4;
  kY    = kY + 4;
  s{k}	= sprintf('Ball %d',k);
end

xlabel('x (m)');
ylabel('y (m)');
set(gca,'ylim',d.yLim,'xlim',d.xLim);
legend(l,s)
grid


%% Implement the Kalman Filter

% Covariances
r0      = sigMeas^2*[1;1];	% Measurement covariance
q0      = [1;60;1;60];      % The baseline plant covariance diagonal
p0      = [0.1;1;0.1;1];	% Initial state covariance matrix diagonal

% Plant model
a       = [1 dT;0 1];
b       = [dT^2/2;dT];
zA      = zeros(2,2);
zB      = zeros(2,1);

% Create the Kalman Filter data structures. a is for two balls.
for k = 1:d.nBalls
  kf(k) = KFInitialize( 'kf', 'm', x0(4*k-3:4*k), 'x', x0(4*k-3:4*k),...
                        'a', [a zA;zA a], 'b', [b zB;zB b],'u',[0;0],...
                        'h', [1 0 0 0;0 0 1 0], 'p', diag(p0), ...
                        'q', diag(q0),'r', diag(r0) );
 end

% Size arrays for plotting
pUKF = zeros(4*d.nBalls,n);
xUKF = zeros(4*d.nBalls,n);
t    = 0;

for k = 1:n
  % Run the filters
  for j = 1:d.nBalls
    
    % Store for plotting
    i         = 4*j-3:4*j;
    pUKF(i,k)	= diag(kf(j).p);
    xUKF(i,k)	= kf(j).m;

    % State update
    kf(j).t   = t; 
    kf(j)     = KFPredict( kf(j) );  

    % Incorporate the measurements
    i         = 2*j-1:2*j;
    kf(j).y   = y(i,k);
    kf(j)     = KFUpdate( kf(j) );
  end

  t = t + dT;
    
end

% Kalman Filter Errors
dX      = xP - xUKF;

% Plotting
[t,tL]	= TimeLabel((0:(n-1))*dT);
pL      = {'p_x'  'p_{v_x}' 'p_y' 'p_{v_y}' 'd'};
yL      = {'x'  'v_x' 'y' 'v_y'};
    
for j = 1:d.nBalls
  i = 4*j-3:4*j;    
  s = sprintf('Ball %d: KF Covariance',j);
  PlotSet(t,[pUKF(i,:)], 'x label',tL,'y label', pL,'figure title', s );
  s = sprintf('Ball %d: KF Errors',j);
  PlotSet(t,dX(i,:), 'x label', tL,'y label', yL,'figure title', s );  
end 
