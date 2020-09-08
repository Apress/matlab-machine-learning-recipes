%% GENERALBELLMF General bell membership function
%% Form:
%  y = GeneralBellMF(x,params)
%% Inputs
%  x        (1,n) The crisp input(s), or []
%  params   (1,m) The vector of parameters
%% Outputs
%  y        (1,:) The resulting vector, or a cell array of parameter names

function y = GeneralBellMF(x,params)

if (nargin == 0)
  set.name = 'Example of General Bell Membership Function';
  set.comp = {''};
  set.type = {'GeneralBell'};
  set.params = {[2 2 5]};
  set.range = [0 10];
  FuzzyPlot(set)
  text(7,0.9,'Parameter values: [2 2 5]')
  return
end

if (isempty(x))
  y = {'Width','Slope','Center'};
else
  a = params(1);
  b = params(2);
  c = params(3);
  
  y = 1./(1 + abs((x-c)/a).^(2*b));
end
