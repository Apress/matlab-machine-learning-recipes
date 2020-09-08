function [a, b] = DoubleIntegratorWithAccel( dT )

%% DOUBLEINTEGRATORWITHACCEL Plant model for a double integrator with an acceleration state.
% State vector is [x;v;a]. Input vector is [0;0;da/dt]
%% Form:
%   [a, b] = DoubleIntegratorWithAccel( dT )
%% Inputs
%   dT       (1,1)  Time step
%
%% Outputs
%   a        (3,3)  State transition matrix
%   b        (3,1)  Input matrix

%--------------------------------------------------------------------------
%	Copyright (c) 2013 Princeton Satellite Systems, Inc.
%   All rights reserved.
%--------------------------------------------------------------------------

% Demo
if( nargin < 1 )
  dT     = 2;
  DoubleIntegratorWithAccel( dT );
  return;
end

a = [1 dT 0.5*dT^2;...
  0  1     dT;...
  0  0      1];

b = [0;0;1];

% Print the matrices if no outputs are specified
if( nargout == 0 )
  fprintf(1,'\nState transition matrix\n\n')
  disp(a)
  fprintf(1,'\nInput matrix\n\n')
  disp(b)
  fprintf(1,'\nState vector is [x;v;a]. Input vector is [0;0;da/dt]\n\n')
  
  clear a;
end

