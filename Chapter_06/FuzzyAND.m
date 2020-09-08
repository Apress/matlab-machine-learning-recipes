%% FUZZYAND Fuzzy AND operator.
% This is the minimum of the membership values.
%% Form:
%  y = FuzzyAND( dom )
%
%% Inputs
%   dom       (1,:) Vector of membership values
%
%% Outputs
%   y         (1,1) Scalar output

function y = FuzzyAND( dom )

y = min( dom );
