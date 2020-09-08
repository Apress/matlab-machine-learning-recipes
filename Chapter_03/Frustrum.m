
%% FRUSTRUM Generate a frustrum of a cone.
% Type Frustrum for a demo.
%% Form:
%   [v, f] = Frustrum( rL, r0, l, n, topOpen, bottomOpen )
%% Inputs
%   rL           (1,1) Top radius    (z = l)
%   r0           (1,1) Bottom radius (z = 0)
%   l            (1,1) Length
%   n            (1,1) Number of divisions
%   topOpen      (1,1) 1 if top is open
%   bottomOpen   (1,1) 1 if bottom is open
%   
%% Outputs
%   v           (:,3) Vertices
%   f           (:,3) Faces
%

function [v, f] = Frustrum( rL, r0, l, n, topOpen, bottomOpen )

if( nargin < 4 )
  n = [];
end

if( nargin < 5 )
  topOpen = [];
end

if( nargin < 6 )
  bottomOpen = [];
end

if( nargin < 1 )
  rL = 1;
  r0 = 0.5;
  l  = 2;
  n  = 24;
  topOpen = 1;
  bottomOpen = 0;
end

if( isempty(n) )
  n = 10;
end

if( isempty(topOpen) )
  topOpen = 0;
end

if( isempty(bottomOpen) )
  bottomOpen = 0;
end

angle = linspace(0,2*pi,n+1)';
angle = angle(1:(end-1));
cS    = [cos(angle) sin(angle)];
v     = [ 0 0 0;...
          r0*cS  zeros(n,1);...
          rL*cS l*ones(n,1);...
          0 0 l];
		  

% Vertices
%
% 0 0 0
% Top    rim 2:(n+1)
% Bottom rim (n+2):(2n+2)
% 0 0 l 

k1T = 2;
k2T = n+1;
k1B = n+2;
k2B = 2*n+1;
kBC = 2*n+2;

kT  = (k1T:k2T)';
kB  = (k1B:k2B)';
kBO = [((k1B+1):k2B)';k1B];
kTO = [((k1T+1):k2T)';k1T];

% Cone
%-----
f = [kT   kBO kB; kBO  kT  kTO ];

% Top cap
%--------
if( ~topOpen )
  f = [fliplr([ones(n,1) kT kTO]);f];
end

% Bottom cap
%--------
if( ~bottomOpen )
  f = [f;[kBC*ones(n,1) kB kBO]];
end
	 
if( nargout == 0 )
  DrawVertices(v,f,'Frustrum')
  clear v
end


