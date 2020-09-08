%% Day/night detector
% Demonstrates a perceptron. The sun detector points at zenith. 
% Starts at noon.
%
%% See also
% PlotSet

%% The data
t = linspace(0,24);        % time, in hours
d = zeros(1,length(t));
s = cos((2*pi/24)*(t-12)); % solar flux model

%% The activation function
% The nonlinear activation function which is a threshold detector
j    = s < 0;
s(j) = 0;
j    = s > 0;
d(j) = 1;

%% Plot the results
PlotSet(t,[s;d],'x label','Hour', 'y label',...
  {'Solar Flux', 'Day/Night'}, 'figure title','Daylight Detector',...
  'plot title', 'Daylight Detector');
set([subplot(2,1,1) subplot(2,1,2)],'xlim',[0 24],'xtick',[0 6 12 18 24]);
