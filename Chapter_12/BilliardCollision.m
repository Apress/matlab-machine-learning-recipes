function x = BilliardCollision( x, d )

%% BILLIARDCOLLISION Billiard collision model.
% Models wall collisions.
%% Form:
%   x = BilliardCollision( x, d )
%% Inputs
%   x	 (4*nBalls,1)	  State [x;vX;y;vY]
%   t    (1,1)        Unused.
%   d    (.)          Data structure
%                       .nBalls (1,1) Number of balls
%                       .xLim   (1,2) [xMin xMax]
%                       .yLim   (1,2) [yMin yMax]
%% Outputs
%   x	 (4*nBalls,1)	  State [x;y;vX;vY]

%--------------------------------------------------------------------------
%	Copyright (c) 2013 Princeton Satellite Systems, Inc.
%   All rights reserved.
%--------------------------------------------------------------------------

% Collisions
%-----------
for j = 1:d.nBalls
  i = 4*j-3;
  if( x(i) >= d.xLim(2) )
    dT      = (x(i) - d.xLim(2))/x(i+1);
    x(i)    = d.xLim(2);
    x(i+2)  = x(i+2) - dT*x(i+3);
    x(i+1)  = -x(i+1);
  end
  if( x(i) <= d.xLim(1) )
    dT      = (x(i) - d.xLim(1))/x(i+1);
    x(i)    = d.xLim(1);
    x(i+2)  = x(i+2) - dT*x(i+3);
    x(i+1)	= -x(i+1);
  end
  if( x(i+2) >= d.yLim(2) )
    dT      = (x(i+2) - d.yLim(2))/x(i+3);
    x(i+2)  = d.yLim(2);
    x(i)    = x(i) - dT*x(i+1);
    x(i+3)  = -x(i+3);
  end
  if( x(i+2) <= d.yLim(1) )
    dT      = (x(i+2) - d.yLim(1))/x(i+3);
    x(i+2)  = d.yLim(1);
    x(i)    = x(i) - dT*x(i+1);
    x(i+3)  = -x(i+3);
  end
end

