function d = BuildFuzzySystem(varargin)

%% BUILDFUZZYSYSTEM Builds a fuzzy logic system data structure. 
% As you build the system you must input id for inputs, outputs and rules. The
% default is 1.
%% Form
%  d = BuildFuzzySystem(varargin)
%
%% Inputs
%   varargin {:} Parameter pairs
%                 id              Index for the input, output or rule
%                 input comp      Cell array of label strings
%                 input type      'Trapezoid'  or 'Triangle'
%                 input name      Name of input
%                 input params    Parameters defining the input
%                 input range     Input range
%                 output comp     Cell array of label strings
%                 output type     'Trapezoid'  or 'Triangle'
%                 output name     Name of output
%                 output params   Parameters defining the output
%                 output range    Output range
%                 rule input      Input indices (match rule to input)
%                 rule output     Output indices (match rule to output)
%                 rule operator   Rule operator (fuzzy and or or)
%                 implicate       Implicate method
%                 aggregate       Aggregation method
%                 defuzzify       Type of defuzzifier
%                 data            Data for the fuzzy system
%
%% Outputs
%   d       (.)	Data structure
%

% The default data is from the Smart Wipers demo
d = load('SmartWipers');

j = 1;

for k = 1:2:length(varargin)
  switch (lower(varargin{k}))
    case 'id'
      j = varargin{k+1};
    case 'input comp'
      d.input(j).comp = varargin{k+1};
    case 'input type'
      d.input(j).type = varargin{k+1};
    case 'input name'
       d.input(j).name = varargin{k+1};
    case 'input params'
      d.input(j).params = varargin{k+1};
    case 'input range'
      d.input(j).range = varargin{k+1};
    case 'output comp'
      d.output(j).comp = varargin{k+1};
    case 'output type'
      d.output(j).type = varargin{k+1};
    case 'output name'
      d.output(j).name = varargin{k+1};
    case 'output params'
      d.output(j).params = varargin{k+1};
    case 'output range'
      d.output(j).range = varargin{k+1};
    case 'rule input'
      d.rules(j).input = varargin{k+1};
    case 'rule output'
      d.rules(j).output = varargin{k+1};
    case 'rule operator'
       d.rules(j).operator = varargin{k+1};
    case 'implicate'
        d.implicate = varargin{k+1};
    case 'aggregate'
       d.aggregate = varargin{k+1};
    case 'defuzzify'
        d.defuzzify = varargin{k+1};
    case 'data'
        d.data = varargin{k+1};
    otherwise
      fprintf(1,'%s not available\n',varargin{k});
  end
end
      
