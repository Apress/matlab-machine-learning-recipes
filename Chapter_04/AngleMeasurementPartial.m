%% ANGLEMEASUREMENTPARTIAL Function for an angle measurement derivative
%% Form
%  h = AngleMeasurementPartial( x, d )
%
%% Description
% Partial derivative of the angle measurement, which is an arctangent from a
% baseline.
%
%% Inputs
%  x       (2,1) State [r;v]
%  d       (.)   Data structure
%                .baseline (1,1) Baseline
%
%% Outputs
%  y       (1,1) Angle

function h = AngleMeasurementPartial( x, d )

if( nargin < 1 )
  h = struct('baseline',10);
  return
end

% y = atan(x(1)/d.baseline);

u   = x(1)/d.baseline;
dH  = 1/(1+u^2);
h   = [dH 0]/d.baseline;
