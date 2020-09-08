%% SCALEIMP Scale implication function
%% Form:
%  z = ScaleIMP( y, c )
%% Inputs
%  y        (1,:) The vector to be scaled
%  c        (1,1) The scaling value
%% Outputs
%  z        (1,:) The resulting vector

function z = ScaleIMP( y, c )

z = y*c;
