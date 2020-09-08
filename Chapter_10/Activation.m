%% ACTIVATION Implement activation functions
%% Form
% s = Activation( type, x, k )
% Activation % Demo
%
%% Description
% Generates an activation function
%
%% Inputs
%
%  type (1,:) Type 'sigmoid', 'tanh', 'rlo', 'linear'
%  x  	(1,:) Input
%  k    (1,1) Scale factor
%
%% Outputs
%
%  s  (1,:) Output
%

function s = Activation( type, x, k )

% Demo
if( nargin < 1 )
  Demo
  return
end

if( nargin < 3 )
  k = 1;
end

switch lower(type)
  case {'rlo' 'rectified linear output'}
    j = x <= 0;
    s = x;
    s(j) = 0;
  case 'tanh'
    s = tanh(k*x);
  case 'sigmoid'
    s = (1-exp(-k*x))./(1+exp(-k*x));
  case 'linear'
    s = x;
  otherwise
    disp('%s not available. Using tanh');
    s = x;   
end

function Demo
%% Activation>Demo
% Show different activation functions
x	= linspace(-2,2);
s	= [ Activation('rlo',x);...
      Activation('tanh',x);...
      Activation('linear',x);...
      Activation('sigmoid',x)];

PlotSet(x,s,'x label','x','y label','\sigma(x)',...
        'figure title','Activation Functions',...
        'legend',{{'RLO' 'tanh'  'Linear' 'Sigmoid'}},'plot set',{1:4});

