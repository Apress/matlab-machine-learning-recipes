function d = BuildExpertSystem(d, varargin)

%% BUILDEXPERTSYSTEM Builds or expands a case based expert system. 
%% Form
%  d = BuildExpertSystem(d, varargin)
%% Inputs
%   d         (.) Existing system data structure (can be empty)
%   varargin  {:} Parameter pairs
%                 catalog state name	States in the system
%                 catalog value       Their possible values
%                 case states         Case states
%                 case values         Case values
%                 case outcome       	Case outcome
%                 match percent       Match percent (0-100)
%% Outputs
%   d       (.)	System data structure

% You can load in an old catalog and update
if( isempty(d) )
  d     = DefaultSystem;
  jCat  = 0;
  jCase = 0;
else
  jCat  = length(d.stateCatalogData.values);
  jCase = length(d.case);
end

j = 1;
for k = 1:2:length(varargin)
  switch (lower(varargin{k}))
    case 'id'
      j = varargin{k+1};
    case 'catalog state name'
      d.stateCatalogData.state{j+jCat} = varargin{k+1};
    case 'catalog value'
      d.stateCatalogData.values{j+jCat} = varargin{k+1};
    case 'case states'
      d.case(j+jCase).activeStates = varargin{k+1};
    case 'case values'
      d.case(j+jCase).values = varargin{k+1};
    case 'case name'
      d.case(j+jCase).name = varargin{k+1};
    case 'case outcome'
      d.case(j+jCase).outcome = varargin{k+1};
    case 'match percent'
      d.matchPercent= varargin{k+1};
     otherwise
      fprintf(1,'%s not available\n',varargin{k});
  end
end

% Create a default system to demonstrate the structure
function system =  DefaultSystem

catalog.state         	= {'wheel-turning','power' 'torque-command'};
catalog.values          = {{'yes','no'},{'on','off'},{'yes','no'}};
system.cases            = struct('name','Wheel working','activeStates',1:3,'values',{'yes' 'on' 'yes'},'outcome','working');
system.matchPercent     = 100;
system.stateCatalogData = catalog;


