function [y, del] = MHTDistance( s )

%% MHTDISTANCE Finds the MHT distance for use in gating computations.
%   The measurement function is of the form h(x,d) where d is a data
%   structure.
%
%   The most time consuming operation is this operation
%
%     (z-h*x)'*b \ (z-h*x)
%
%   where b = h*p*h' + r
%
%   The matrix inversion of b is of the order of the measurement vector.
%
%   As the uncertainty gets smaller, the residual must be smaller to remain
%   within the gate. 
%
%   Type MHTDistance for a demo of a rectilinear motion problem. The
%   vehicle is under constant acceleration. The measurement is distance
%   from the origin. A linear Kalman filter is used which is implemented 
%   with KFPredict and KFUpdate.
%
%   See MHTDistanceUKF for an alternative approach.
%% Form:
%   [y, del] = MHTDistance( s )
%% Inputs
%   s        (1,1)  Data structure for the filter
%
%% Outputs
%   y        (1,1)  MHT distance
%   del      (1,1)  MHT Residual
%

%--------------------------------------------------------------------------
%	  Copyright (c) 2013, 2018 Princeton Satellite Systems, Inc.
%   All rights reserved.
%--------------------------------------------------------------------------

% Demo
%-----
if( nargin < 1 )
  % Time vector
  %------------
  t       = linspace(0,10);
  dT      = t(2) - t(1);

  % Filter
  %-------
  s.r     = 2^2;
  s.u     = 0.01;
  s.a     = [1 dT;0 1];
  s.b     = [0.5*dT^2;dT];
  s.m     = [0;0];
  s.p     = diag([0.01;0.0001]);
  s.q     = diag([0.001;0.004]);
  s.h     = [1 0];

  % Simulation
  %-----------
  n       = length(t);
  y       = zeros(1,n);
	x       = [0.5*s.u*t.^2;s.u*t];
	z       = x(1,:) + sqrt(s.r)*randn;

  for k = 1:n
    s       = KFPredict( s );
    s.y     = z(1,k);
    s       = KFUpdate( s );
    s.x     = x(:,k);
    y(1,k)	= MHTDistance( s );
  end

  % Plot
  %-----
  [t, tL] = TimeLabel(t);
  PlotSet(t,y,'x label',tL,'y label','Distance','plot title','MHT Distance');
  clear y;
  return;
end

% If there is an hData field this is a nonlinear Kalman Filter
%-------------------------------------------------------------
if( isstruct(s.y) )
  [del, h, r]	= Residual( s.y, s );
else
	h = s.h;
  if( isstruct(s.y) )
    del	= s.y.data - h*s.x;
  else
    del = s.y - h*s.x;
  end
  r = s.r;
end

% Compute the distance
%---------------------
b = h*s.p*h' + r;
y	= del'*(b\del);

