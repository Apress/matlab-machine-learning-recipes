%% GAUSSIANMF Gaussian membership function
%% Form:
%  y = GaussianMF( x,params )
%% Inputs
%  x        (1,n) The crisp input(s), or []
%  params   (1,m) The vector of parameters
%
%% Outputs
%  y        (1,:) The resulting vector, or a cell array of parameter names

function y = GaussianMF(x,params)

if nargin == 0
  set.name = 'Example of Gaussian Membership Function';
  set.comp = {''};
  set.type = {'Gaussian'};
  set.params = {[2 5]};
  set.range = [0 10];
  FuzzyPlot(set)
  text(6,0.9,'Parameter values: [2 5]')
  return
end

if isempty(x)
  y = {'Width','Center'};
else
  a = params(1);
  c = params(2);
  
  y = exp(-(x-c).^2./a^2);
end
