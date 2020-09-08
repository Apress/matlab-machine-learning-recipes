%% SIGMOIDALMF Sigmoidal membership function
%% Form:
%  y = SigmoidalMF(x,params)
%% Inputs
%  x        (1,n) The crisp input(s), or []
%  params   (1,m) The vector of parameters
%% Outputs
%  y        (1,:) The resulting vector, or a cell array of parameter names

function y = SigmoidalMF(x, params)

if (nargin == 0)
  set.name = 'Example of Sigmoidal Membership Function';
  set.comp = {'',''};
  set.type = {'Sigmoidal','Sigmoidal'};
  set.params = {[1 6],[-0.1 3]};
  set.range = [0 10];
  FuzzyPlot(set)
  text(6.5,0.45,'Parameter values: [1 6]')
  text(3,0.9,'Parameter values: [-0.1 3]')
  return
end

if (isempty(x))
  y = {'Slope','Center'};
else
  a = params(1);
  c = params(2);
  
  y = 1./(1+exp(-(1/a)*(x-c)));
end
