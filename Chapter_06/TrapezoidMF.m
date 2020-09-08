%% TRAPEZOIDMF Trapezoid membership function
%% Form:
%  y = TrapezoidMF(x,params)
%% Inputs
%  x        (1,n) The crisp input(s), or []
%  params   (1,m) The vector of parameters
%% Outputs
%  y        (1,:) The resulting vector, or a cell array of parameter names

function y = TrapezoidMF(x,params)

if (nargin == 0)
  set.name = 'Example of Trapezoid Membership Function';
  set.comp = {''};
  set.type = {'Trapezoid'};
  set.params = {[1 3 5 7]};
  set.range = [0 10];
  FuzzyPlot(set)
  text(6,0.9,'Parameter values: [1 3 5 7]')
  return
end
  
if (isempty(x))
  y = {'a','b','c','d'};
else
  a = params(1);
  b = params(2);
  c = params(3);
  d = params(4);
  
  y     = zeros(size(x));
  k     = find( x<b & x>=a );
  y(k)  = (x(k)-a)/(b-a);
  k     =  x<c & x>=b ;
  y(k)  = 1;
  k     = find( x<d & x>=c ); 
  y(k)  = (d-x(k))/(d-c);
end
