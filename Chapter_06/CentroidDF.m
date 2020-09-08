function c = CentroidDF( y, x )
%% Centroid defuzzification
%% Form:
%  c = CentroidDF( y, x )
%% Inputs
%  y    (1,:) The y-values formed by fuzzy inference
%  x    (1,:) The x-values corresponding to the aggregate
%% Outputs
%  c    (1,1) The resulting x-value

%   Copyright 1999, 2-18 Princeton Satellite Systems, Inc. All rights reserved.

c = sum(y.*x)/sum(y);
