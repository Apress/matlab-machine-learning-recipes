%% One dimensional MHT demo.
% One dimensional MHT test with two vehicles with random accelerations.
%
% The vehicles also have a steady acceleration. The vehicles start a
% distance apart determined by a uniform random number between 0 and 1.
%
% Initially, we do not know how many vehicles we have.
% The plant model has a position, velocity and acceleration state. The
% measurement is the position of each vehicle, with noise.
%
% The demo uses the Kalman Filter (KF). It takes only a few seconds.
%
%% See also DoubleIntegratorWithAccel, ScanToTrack1D, PlotTracks

%% Initialize

% Set the seed for the random number generators. 
% If the seed is not set each run will be different.
seed = 45198;
rng(seed);

% Parameters
n       = 180;               % Number of steps
r0      = 1e-2;             % Measurement 1-sigma
dT      = 0.5;              % The time step
aRand   = 0.0001;           % Random acceleration 1-sigma
q0      = [0.02;0.2;0.04];  % The baseline plant covariance diagonal
p0      = [0.2;0.9;1];      % Initial state covariance matrix diagonal

% Initial state vector [s1;v1;a1;s2;v2;a2]
x0      = [20;0;0;0;0;0.01];   

% The state transition matrices for the Kalman Filter
[a, b]  = DoubleIntegratorWithAccel( dT );

% The random acceleration vector
u       = aRand*randn(2,n);

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

% Plot the simulation
[t, tL]	= TimeLabel(dT*(0:n-1));
PlotSet(t,x,'x label',tL,'y label', {'s' 'v' 'a' },'figure title','States','plot set',{[1 4] [2 5] [3 6]});
set(gca,'ylim',[0 0.02]);

%% Create the MHT code

% The covariances
r           = r(1,1);
p           = diag(p0);
q           = diag([0.5*aRand*dT^2;aRand*dT;aRand].^2 + q0);

% Create the Kalman Filter data structure
f = KFInitialize( 'kf', 'm', [0;0;0],  'x', [0;0;0], 'a', a, 'b', b, 'u',0,...
                        'h', h(1,1:3), 'p', p, 'q', q,'r', r );

% Initialize the MHT parameters
[mhtData, trk] = MHTInitialize(	'probability false alarm', 0.001,...
                                'probability of signal if target present', 0.999,...
                                'probability of signal if target absent', 0.001,...
                                'probability of detection', 1, ...
                                'measurement volume', 1.0, ...
                                'number of scans', 3, ...
                                'gate', 0.2,...
                                'm best', 2,...
                                'number of tracks', 1,...
                                'scan to track function',@ScanToTrack1D,...
                                'scan to track data',struct('v',0),...
                                'distance function',@MHTDistance,...
                                'hypothesis scan last', 0,...
                                'prune tracks', true,...
                                'filter type','kf',...
                                'filter data', f,...
                                'remove duplicate tracks across all trees',true,...
                                'average score history weight',0.01,...
                                'create track', '');                           
                            
% Size arrays
m               = zeros(3,n);
p               = zeros(3,n);
scan            = cell(1,n);
b               = MHTTrkToB( trk );

TOMHTTreeAnimation( 'initialize', trk );
TOMHTTreeAnimation( 'update', trk );

% Initialize the MHT GUI
MHTGUI;
MLog('init')
MLog('name','MHT 1D Demo')

t = 0;

for k = 1:n

  % Get the measurements
  zScan = AddScan( z(1,k) );
  zScan = AddScan( z(2,k), [], zScan );

  % Manage the tracks
  [b, trk, sol, hyp] = MHTTrackMgmt( b, trk, zScan, mhtData, k, t );
    
  % Update MHTGUI display
  MHTGUI(trk,sol,'update');

  % A guess for the initial velocity of any new track
  for j = 1:length(trk)
      mhtData.fScanToTrackData.v = mhtData.fScanToTrackData.v + trk(j).m(1);
  end
  mhtData.fScanToTrackData.v = mhtData.fScanToTrackData.v/length(trk);    

  % Animate the tree
	TOMHTTreeAnimation( 'update', trk );
	drawnow;
  t = t + dT;
end

%% Plot the results
PlotTracks(trk(hyp(1).trackIndex));
