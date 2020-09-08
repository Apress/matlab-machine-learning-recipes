%% Damping ratio Demo
% Demonstrate an oscillator with different damping ratios. 
%% See also
% RungeKutta, RHSOscillator, TimeLabel

%% Initialize
nSim    = 10000;             % Number of simulation steps
dT      = 0.01;              % Time step (sec)
d       = RHSOscillator;    % Get the RHS default data structure
d.a     = 0.0;              % Disturbance acceleration
d.omega = 0.2;              % Oscillator frequency
zeta    = [0 0.2 0.7071 1]; % Array of damping ratios

%% Simulation
xPlot = zeros(length(zeta),nSim);
s     = cell(1,4);

for j = 1:length(zeta)
  % Initial state [position;velocity]
  x = [0;1];
  % Select damping ratio from array
  d.zeta= zeta(j);
           
  % Print a string for the legend
  s{j} = sprintf('zeta = %6.4f',zeta(j));
  for k = 1:nSim
    % Plot storage
    xPlot(j,k)  = x(1);
  
    % Propagate (numerically integrate) the state equations
    x  = RungeKutta( @RHSOscillator, 0, x, dT, d ); 
  end
end

%% Plot the results
[t,tL] = TimeLabel(dT*(0:(nSim-1)));
h = figure('Name','Damping Ratios');
plot(t,xPlot)
xlabel(tL);
ylabel('r');
grid on
legend(s)
