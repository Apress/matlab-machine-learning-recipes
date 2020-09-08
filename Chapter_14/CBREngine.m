%% CBRENGINE Implements a case-based reasoning engine.
% Fits a new case to the existing set of cases.
%% Form:
%   [outcome, pMatch] = CBREngine( newCase, system )
%
%% Inputs
%   newCase     (.) Structure with the new case
%   system      (.) Structure with the system. See BuildExpertSystem
%
%% Outputs
%   outcome     (1,:)  The outcome of the new case
%   pMatch      (1,:)  Match percentage per case
%                           

function [outcome, pMatch] = CBREngine( newCase, system )

% Find the cases that most closely match the given state values
pMatch  = zeros(1,length(system.case));
pMatchF = length(newCase.state); % Number of states in the new case
for k = 1:length(system.case)
  f = min([1 length(system.case(k).activeStates)/pMatchF]);
  for j = 1:length(newCase.state)
    % Does state j match any active states?
    q = StringMatch( newCase.state(j), system.case(k).activeStates );
    if( ~isempty(q) )
      % See if our values match
      i = strcmpi(newCase.values{j},system.case(k).values{q});
      if( i )
        pMatch(k) = pMatch(k) + f/pMatchF;
      end
    end
  end
end

i = find(pMatch == 1);
if( isempty(i) )
  i = max(pMatch,1);
end

outcome = system.case(i(1)).outcome;

for k = 2:length(i)
  if( ~strcmp(system.case(i(k)).outcome,outcome))
    outcome = 'ambiguous';
  end
end
  

function k = StringMatch( testValue, array )

match = strcmpi(testValue,array);
k     = find(match,1);
