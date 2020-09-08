%% POOL Pool values from a 2D array
% Creates an nxn matrix from a. The size of a must be a power of 2. The type can
% be any function name.
%
% Type Pool for a demo.
%
%% Form
% b = Pool( a, n, type )
% Pool % Demo
%
%% Inputs
%
%  a    (:,:) Matrix to be pooled
%  n    (1,1) Number of pools
%  type (1,:) String with pooling type, default is 'mean'
%
%% Outputs
%
%  b  (n,n)  Pool
%
% See also:
% Pool>Demo

function b = Pool( a, n, type )

% Demo
if( nargin < 1 )
  Demo
  return
end

if( nargin <3 )
  type = 'mean';
end

n = n/2;
p = str2func(type);

nA = size(a,1);

nPP = nA/n;

b = size(n,n);
for j = 1:n
  r = (j-1)*nPP +1:j*nPP;
  for k = 1:n
    c = (k-1)*nPP +1:k*nPP;
    b(j,k) = p(p(a(r,c)));
  end
end

function Demo
% Pool>Demo
% Pool a random 4x4 matrix

a = rand(4,4);
disp(a);
Pool( a, 4);
