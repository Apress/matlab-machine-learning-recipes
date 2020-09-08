%% CLIPIMP Clip implication function
%% Form:
%  z = ClipIMP( y, c )
%
%% Inputs
%  y        (1,:) The vector to be clipped
%  c        (1,1) The maximum value
%
%% Outputs
%  z        (1,:) The resulting vector

function z = ClipIMP( y, c )

z = min( y, c );
