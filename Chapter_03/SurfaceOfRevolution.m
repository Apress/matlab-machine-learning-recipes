%% Generate vertices and faces for a surface of revolution about z.
%
%% Form:
%   [v, f] = SurfaceOfRevolution( r, z, n )
%
%% Description
% Creates a surface of revolution about z. It will draw the object
% if no outputs are specified.
%
% Type SurfaceOfRevolution for a demo drawing an ellipsoid.
%
%% Inputs
%   r	(1,:)   Radius at each z
%   z	(1,:)   z length
%   n	(1,1)   Number of segments per revolution (Default 20) 
%
%% Outputs
%   v	(:,3)   Vertices
%   f	(:,3)   Faces
%
%--------------------------------------------------------------------------

function [v, f] = SurfaceOfRevolution( r, z, n )

% Demo
if( nargin < 1 )
  Demo
  return
end

% Default number of segments per revolution
if( nargin < 3 )
  n = 10;
end

ang = linspace(0,2*pi - 2*pi/n,n);
c   = cos(ang);
s   = sin(ang);

m   = length(z);

% Vertices
v   = zeros(n*m,3);
i   = 0;
for j = 1:m
  for k = 1:n
    i      = i + 1;
    v(i,:) = [c(k)*r(j), s(k)*r(j), z(j)];
  end
end

% Faces
f   = zeros(2*n*(m-1),3);
i   = 0;
jB  = [1:n 1];
for j = 1:m-1
  j1 = n*(j-1);
  j2 = j1 + n;
  for k = 1:n
    i = i + 1;
    f(i,:)  = [j1+jB(k) j2+jB(k)   j1+jB(k+1)];
    i       = i + 1;
    f(i,:)  = [j2+jB(k) j2+jB(k+1) j1+jB(k+1)];
  end
end

% Default output
if( nargout == 0 )
  DrawVertices(v,f,'Surface of Revolution');
  clear v
end

function Demo

a = 4;
b = 1;
z = linspace(-a,a,20);
r = b*sqrt(1 - z.^2/a^2);
SurfaceOfRevolution(r,z);
