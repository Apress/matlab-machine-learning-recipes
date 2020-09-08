%% Builds, trains and tests a Neural Net for pendulum prediction.
% Predict the next position of a pendulum based on its previous position and velocity. 
% The Neural Net has one hidden layer with three nodes.
%
%% Reference: Swingler, Kevin, "Applying Neural Networks." p. 20
%% See also: NeuralNetMLFF


% Pendulum parameters
a     = 0.5;                  % amplitude of motion in radians
omega = 0.5;                % frequency in rad/s
tau   = 2*pi/omega;         % period in secs
dT    = tau/100;            % sample 20*omega

% Assemble the nodes
layer       = struct;
layer.type  = 'tanh';
layer.alpha = 1;

trainType   = 'rand';
nSamples    = 100;
nRuns       = 2000;        % number of training runs (not used if 'cont')
nTests      = 500;

% Thresholds
layer(1,1).w0 = rand(3,1) - 0.5;
layer(2,1).w0 = rand(1,1) - 0.5;

% Weights w(i,j) from jth output to ith node
layer(1,1).w  = rand(3,2) - 0.5;
layer(2,1).w  = rand(1,3) - 0.5;

  

% Train the network
if( strcmp(trainType,'cont') == 1 )
  t     = (0:nSamples-1)*dT;
  n     = 1:nSamples;
  nRuns = nSamples;
else
  t  = rand(1,nSamples)*2*tau;
  n  = ceil(rand(1,nRuns)*nSamples); % determines training sets to use
end

yD = a*cos(omega*(t+dT));

x  = [ a   *   cos( omega*( t ) ) ;...
      -a*omega*sin( omega*( t ) ) ];

[w,e,layer] = NeuralNetTraining( x(:,n), yD(:,n), layer );


% Assemble the new network
layerNew(1,1).type = layer(1,1).type;
layerNew(1,1).w    = w(1).w;
layerNew(2,1).w    = w(2).w;
layerNew(1,1).w0   = w(1).w0;
layerNew(2,1).w0   = w(2).w0;

network.layer = layerNew;

% Test the new network
t    = rand(1,nTests)*2*tau;
yD   = a*cos(omega*(t+dT));
xT   = [ a   *   cos( omega*( t ) ) ;...
        -a*omega*sin( omega*( t ) ) ];

y    = NeuralNetMLFF( xT, network );

eTSq = (y-yD).^2;


[Yt,I] = sort(t);

PlotSet(1:nRuns,e.^2,'x label','Sample','y label','Error^2',...
  'figure title','Training Error','plot type','ylog')

PlotSet(1:nTests,eTSq,'x label','Test','y label''Error^2',...
  'figure title','Testing Error','plot type','ylog')

PlotSet([Yt; Yt],[y(I); yD(I)],'x label','Time',...
  'y label',{'Neural Net','Truth'},...
  'figure title','Net Output')




