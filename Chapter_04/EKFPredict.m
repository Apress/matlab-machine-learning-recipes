%% EKFPREDICT Extended Kalman Filter prediction step.
%% Form
%  d = EKFPredict( d )
%
%% Description
% The state propagation step for an extended Kalman Filter.
% It numerically integrates the right hand side using RungeKutta.
%
%% Inputs
%   d	(.)  EKF data structure
%          .m       (n,1)    Mean
%          .p       (n,n)    Covariance
%          .q       (n,n)    State noise
%          .f       (*)      Name/handle of right hand side function
%          .fX      (*)      Function to generate the state transition matrix 
%                              for the right hand side
%          .fData   (1,1)    Data structure with data for f and fX
%          .dT      (1,1)    Time step
%          .t       (1,1)    Time
%
%% Outputs
%   d	(.)  Updated EKF data structure
%          .m       (n,1)    Mean
%          .p       (n,n)    Covariance

function d = EKFPredict( d )

% Get the state transition matrix
if( isempty(d.a) )
  a = feval( d.fX, d.m, d.t, d.dT, d.fData );
else
  a = d.a;
end

% Propagate the mean
d.m = RungeKutta( d.f, d.t, d.m, d.dT, d.fData );

% Propagate the covariance
d.p = a*d.p*a' + d.q;

