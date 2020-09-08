%% Automobile demo simulating a passing car.
% This simulates a car passing another and shows them graphically
% in a 3D display.
%% See also:
% AutomobileInitialize, DrawComponents, AutomobilePassing, RungeKutta

%% Initialize

% Car control
laneChange = 1;

% Clear the data structure
d = struct;

% Car 1 has the radar
d.car(1) = AutomobileInitialize( ...
  'mass', 1513,...
  'position tires', [1.17 1.17 -1.68 -1.68; -0.77 0.77 -0.77 0.77], ...
  'frontal drag coefficient', 0.25, ...
  'side drag coefficient', 0.5, ...
  'tire friction coefficient', 0.01, ...
  'tire radius', 0.4572, ...
  'engine torque', 0.4572*200, ...
  'rotational inertia', 2443.26, ...
  'rolling resistance coefficients', [0.013 6.5e-6], ...
  'height automobile', 2/0.77, ...
  'side and frontal automobile dimensions', [1.17+1.68 2*0.77],...
  'car model','MyCar.obj');

% Make the other car identical
d.car(2) = d.car(1);

% Set up the figure
NewFigure( 'Car Passing' )
axes('DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1] );

h = [];
h(1,:) = DrawComponents( 'initialize', d.car(1).g );
h(2,:) = DrawComponents( 'initialize', d.car(2).g );

xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')

set(gca,'ylim',[-4 4],'zlim',[0 2]);

grid on
view(3)
rotate3d on
hold off

nAuto = length(d.car);

% Velocity set points for the cars
vSet = [12 13]; % m/s

% Time step setup
dT          = 0.1; % sec
tEnd        = 180; % sec
tEndPassing = 360; % sec
n           = ceil(tEnd/dT);

% Car initial states [x;y;vX;vY;theta;omega]
x = [20; 0;10;0;0;0;...
      0; 0;11;0;0;0];

%% Simulate
t = (0:(n-1))*dT;
for k = 1:n
  % Draw the cars
  pos1 = x([1 2]);
  pos2 = x([7 8]);
  DrawComponents( 'update', d.car(1).g, h(1,:), [pos1;pi/2 + x( 5)] );
  DrawComponents( 'update', d.car(2).g, h(2,:), [pos2;pi/2 + x(11)] );
  
  xlim = [min(x([1 7]))-10 max(x([1 7]))+10];
  set(gca,'xlim',xlim);
  drawnow
  
  for i = 1:nAuto
    p          = 6*i-5;
    d.car(i).x = x(p:p+5);
  end
  
  % Implement Control
  
  % For all but the passing car control the velocity
  d.car(1).torque = -10*(d.car(1).x(3) - vSet(1));
  
  % The active car
  if( t(k) < tEndPassing )
    d.car(2)	= AutomobilePassing( d.car(2), d.car(1), 3, 1.3, 10 );
  else
    d.car(2).torque = -10*(d.car(2).x(3) - vSet(2));
  end
  
  % Integrate
  x  = RungeKutta(@RHSAutomobile, 0, x, dT, d );
end

