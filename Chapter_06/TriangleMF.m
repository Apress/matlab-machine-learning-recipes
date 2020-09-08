%% TRIANGLEMF Triangle membership function
%% Form:
%  y = TriangleMF(x,params)
%% Inputs
%  x        (1,n) The crisp input(s), or []
%  params   (1,m) The vector of parameters
%% Outputs
%  y        (1,:) The resulting vector, or a cell array of parameter names

function y = TriangleMF(x,params)

if (nargin == 0)
  set.name = 'Example of Triangle Membership Function';
  set.comp = {''};
  set.type = {'Triangle'};
  set.params = {[2 5]};
  set.range = [0 10];
  FuzzyPlot(set)
  text(6,0.9,'Parameter values: [2 5]')
  return
end

if (isempty(x))
  y = {'Half-width','Center'};
else
  a = params(2);
  b = params(1);
  
  y = max( 1 - abs(x - a)/b, 0);
end
