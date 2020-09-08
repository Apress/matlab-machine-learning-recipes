%% FUZZYPLOT  Plots a fuzzy set
%% Form:
%  FuzzyPlot( set )
%% Inputs
%  set     A struct containing all info on the categories for the fuzzification
%            .name
%            .comp(m)
%            .type(m)
%            .params(m)
%            .range(2)
%
% Note: The comp and type fields should be cell arrays of strings
%       The params fields is a cell array of parameter vectors
%
%% Outputs
%  None
%% 

function FuzzyPlot( set )

if (nargin==0)
  set.name = 'Example of Triangle Membership Function';
  set.comp = {''};
  set.type = {'Triangle'};
  set.params = {[2 5]};
  set.range = [0 10];
  FuzzyPlot(set);
  return;
end

n = length(set.comp);
x = linspace(set.range(1), set.range(2), 200);
y = zeros(n,length(x));

for i = 1:n
  mf = [set.type{i} 'MF']; %  '(x, set.params{i})'
  y(i,:) = feval(mf,x,set.params{i});
  temp = find(y(i,:) == max(y(i,:)));
  v(i) = sum(x(temp))/length(temp);
end

plot(x,y)
axis([x(1) x(end) 0 1.2])
grid on

for i = 1:n  
  if ~isempty(set.comp)
    text(v(i),1.05,set.comp(i))
  end
end

title(sprintf('%s',set.name))
ylabel('Degree of Membership')
xlabel('Crisp Value')
