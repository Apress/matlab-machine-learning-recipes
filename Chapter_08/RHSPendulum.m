%% RHSPENDULUM Right hand side of a pendulum
%% Form
%  xDot = RHSPendulum( ~, x, a )
%
%% Description
% A pendulum dynamics model.
% This can be called by the MATLAB Recipes RungeKutta function or any MATLAB
% integrator. Time is not used.
%
% If no inputs are specified it will return the default data structure.
%
%% Inputs
%  t       (1,1) Time (unused)
%  x       (2,1) State vector [theta;theta dot]
%  d       (.)   Data structure
%                .linear  (1,1) If true use a linear model
%                .omega   (1,1) Input gain
%
%% Outputs
%  xDot    (2,1) State vector derivative
%
%% References
% None.

function xDot = RHSPendulum( ~, x, d )

if( nargin < 1 )
  xDot = struct('linear',false,'omega',0.5);
  return
end

if( d.linear )
  f = x(1);
else
  f = sin(x(1));
end  

xDot = [x(2);-d.omega^2*f];

