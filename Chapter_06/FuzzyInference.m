%% Fuzzy Inference engine
% Performs fuzzy inference given a fuzzy system and crisp data x
%
%% Form:
%  y = FuzzyInference( x, system )
%
%% Inputs
%  x          crisp input vector
%  system     fuzzy system
%
%% Outputs
%  y          crisp output vector
%

function y = FuzzyInference( x, system )

if length(x) == length( system.input )
  fuzzyX   = Fuzzify( x, system.input );
  strength = Fire( fuzzyX, system.rules );
  y        = Defuzzify( strength, system );
else
  warndlg({'The length of x must be equal to the',...
           'number of input sets in the system.'})
end

function fuzzyX = Fuzzify( x, sets )

m = length(sets);
fuzzyX = cell(1,m);
for i = 1:m
  n = length(sets(i).comp);
  range = sets(i).range(:);
  if range(1) <= x(i) <= range(2)
    for j = 1:n
      fuzzyX{i}(j) = eval([sets(i).type{j} 'MF(x(i),[' num2str(sets(i).params{j}) '])']);
    end
  else
    fuzzyX{i}(1:n) = zeros(1,n);
  end
end

function strength = Fire( FuzzyX, rules )

m = length( rules );
n = length( FuzzyX );

strength = zeros(1,m);

for i = 1:m
  method = rules(i).operator;
  for j = 1:n
    comp = rules(i).input(j);
    if comp ~= 0
      dom(j) = FuzzyX{j}(comp);
    else
      dom(j) = inf;
    end
  end
  strength(i) = eval([method '(dom(find(dom<=1)))']);
end
 
function result = Defuzzify( strength, system )

rules   = system.rules;
output  = system.output;

m       = length( output );
n       = length( rules );
imp     = system.implicate;
agg     = system.aggregate;
defuzz  = system.defuzzify;
result  = zeros(1,m);

for i = 1:m
  range = output(i).range(:);
  x = linspace( range(1),range(2),200 );
  for j = 1:n
    comp = rules(j).output(i);    
    if( comp ~= 0 )
      mf        = [output(i).type{comp} 'MF'];
      params    = output(i).params{comp};
      mem(j,:)  = eval([ imp 'IMP(' mf '(x,params),strength(j))']);
    else
      mem(j,:)  = zeros(size(x));
    end
  end
  aggregate = eval([ agg '(mem)' ]);
  result(i) = eval([ defuzz 'DF(aggregate, x)']);
end

