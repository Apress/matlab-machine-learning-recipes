function xDot = RHSBilliards( ~, x, d )

%% RHSBILLIARDS Billiard ball model.
% 2D double integrators. Time is not needed but the function follows the
% standard format for integration RungeKutta.
%% Form:
%   xDot = RHSBilliards( t, x, d )
%% Inputs
%   x	 (4*nBalls,1)	    State [x;y;vX;vY]
%   t    (1,1)          Unused.
%   d    (1,1)          Data structure
%% Outputs
%   xDot (4*nBalls,1)	  State d[x;y;vX;vY]/dt

%--------------------------------------------------------------------------
%   Copyright (c) 2018 Princeton Satellite Systems, Inc.
%   All rights reserved.
%--------------------------------------------------------------------------

xDot = zeros(4*d.nBalls,1);

for k = 1:d.nBalls
    j         = 4*k - 3;
    xDot(j  ) = x(j+1);
    xDot(j+2) = x(j+3);
end
