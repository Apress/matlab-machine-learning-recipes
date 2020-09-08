%% KFINITIALIZE Kalman Filter initialization
%% Form
%   d = KFInitialize( type, varargin )
%
%% Description
% Initializes Kalman Filter data structures for the KF, UKF,  EKF and
% UKFP, parameter update.
%
% Enter parameter pairs after the type. 
%
% If you return with only one input it will return the default data
% structure for the filter specified by type. Defaults are returned
% for any parameter you do not enter. x will automatically be initialized to
% the same value as m.
%
%%  Inputs
%   type           ''    Type of filter 'kf', 'ekf', 'ukf', 'ukfp'
%   varargin       {:}   Parameter pairs
%
%% Outputs
%   d              (.)   Data structure
%
%% References
% None.

function d = KFInitialize( type, varargin )

% Default data structures
switch lower(type)
  case 'ukf'
    d = struct( 'm',[],'alpha',1, 'kappa',0,'beta',2, 'dT',0,...
                'p',[],'q',[],'f','','fData',[], 'hData',[],'hFun','','t',0,'r',[]);  

  case 'kf'
    d = struct( 'm',[],'a',[],'b',[],'u',[],'h',[],'p',[],...
                'q',[],'r',[], 'y',[]); 
               
  case 'ekf'
    d = struct( 'm',[],'x',[],'a',[],'b',[],'u',[],'h',[],'hX',[],'hData',[],...
                'f',[],'fX',[],'fData',[],'p',[],'q',[],'r',[],'t',0, 'y',[],...
                'v',[],'s',[],'k',[], 'dT',0);  
              
  case 'ukfp'
    d = struct( 'm',[],'alpha',1, 'kappa',0,'beta',2, 'dT',0,'x',[],'p',[],'q',[],...
                'r',[],'f','','fData',[], 'hData',[],'hFun','','t',0,'eta',[]);  
              
  otherwise
    error([type ' is not available']);
end
  
% Return the defaults
if( nargin == 1 )
    return
end

% Cycle through all the parameter pairs
for k = 1:2:length(varargin)
  name = varargin{k};
  if ~isfield(d,name)
    error('KFInitialize: Unknown field: %s\n',name)
  end
  d.(name) = varargin{k+1};
  if (strcmp(name,'m') || strcmp(name,'x'))
    d.m = varargin{k+1};
    d.x = varargin{k+1};
  end
end
