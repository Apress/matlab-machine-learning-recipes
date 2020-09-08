%% FUZZYOR Fuzzy OR operator.
% THis is the maximum of the membership values.
%% Form:
%  y = FuzzyOR( dom )
% 
%% Inputs
%   dom       (1,:) Vector of membership values
%
%% Outputs
%   y         (1,1) Scalar output

function y = FuzzyOR( dom )

y = max( dom );
