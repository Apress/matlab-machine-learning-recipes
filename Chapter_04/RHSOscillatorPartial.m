%% RHSOSCILLATORPARTIAL The discrete time state transition matrix for an oscillator
%% Form
%  a = RHSOscillatorPartial( x, t, dT, d)
%  a = RHSOscillatorPartial
%
%% Description
% State transition matrix for the osciallator right hand side given the
% time step dR.
%
% If no arguments are entered, it returns the default data structure.
%
%% Inputs
%  x       (2,1) State [r;v]  (unused)
%  t       (1,1) Time (s) (unused)
%  dT      (1,1) Time step (s)
%  d       (.)   Data structure
%                .zeta  (1,1) Damping ratio
%                .omega (1,1) Undamped natural frequency (rad/s)
%
%% Outputs
%  a       (2,2) State transition matrix


function a = RHSOscillatorPartial( ~, ~, dT, d )

if( nargin < 1 )
  a = struct('zeta',0.7071,'omega',0.1);
  return
end

b = [0;1];
a = [0 1;d.omega^2 -2*d.zeta*d.omega];
a = CToDZOH( a, b, dT );


