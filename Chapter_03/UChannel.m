function [v, f] = UChannel( x, y, z, t, d, b )

%% Generate a box with a u cut at the +x end.
% Type UChannel for a demo. With no outputs UChannel will draw your object.
%--------------------------------------------------------------------------
%   Form:
%   [v, f] = UChannel( x, y, z, t, d, b )
%--------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   x           (1,1)  x length
%   y           (1,1)  y length
%   z           (1,1)  z length
%   t           (1,1)  Flange thickness
%   d           (1,1)  Depth of cut in x
%   b           (3,3)  Transformation matrix (Default is eye(3))
%   
%
%   -------
%   Outputs
%   -------
%   v           (16,3) Vertices
%   f           (12,3) Faces
%
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%   Copyright (c) 2013, 2017 Princeton Satellite Systems, Inc.
%   All rights reserved.
%--------------------------------------------------------------------------
%   2017.1 Update drawing to use DrawVertices
%--------------------------------------------------------------------------

% Demo
%-----
if( nargin < 1 )
  UChannel( 8, 2, 2, 0.3, 2 );
  return
end

% One side
%---------
z = z/2;
y = y/2;
v = [0   0  z;...     %1
     x   0  z;...     %2
     x   0  z-t;...   %3
     x-d 0  z-t;...   %4
     x-d 0 -z+t;...   %5
     x   0 -z+t;...   %6
     x   0 -z;...     %7
     0   0 -z];       %8
 
 
vN      = v;
vN(:,2)	= vN(:,2) - y;
vP      = v;
vP(:,2) = vP(:,2) + y;

v       = [vN;vP];

f       = [1 4 2;...
           4 3 2;...
           8 4 1;...
           8 5 4;...
           8 7 5;...
           5 7 6];
       
f       = [f;f+8];
f       = [f;...
             1  2  9;... % +Y
             9  2 10;...
             8 16  7;... % -Y
            16 15  7;...
             1  9  8;... % -X
             8  9 16;...
             4  5 12;... % +X
            12  5 13;...
             6  7 14;... % -Z Tip
             7 15 14;...
             3 10  2;... % +Z Tip
             3 11 10;...
             4 12  3;... % +Z Inside face
             3 12 11;...
             5  6 14;... % -Z Inside face
             5 14 13];
         
if( nargin > 5 )
    v = (b*v')';
end

% Draw the channel
%-----------------
if( nargout == 0 )
  DrawVertices( v, f, 'U Channel' )
  clear v
end


%--------------------------------------
% $Date: 2018-07-09 15:09:14 -0400 (Mon, 09 Jul 2018) $
% $Revision: 46720 $
