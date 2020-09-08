%% TIMELABEL Produce time labels and scaled time vectors
%% Form
%  [t, u, s] = TimeLabel( t )
%
%% Decription
% Generates a time series from a time series in seconds with more 
% reasonable units: minutes, hours, days, or years.
%
%% Inputs
%  t         (1,:)  Time series (s)
%
%% Outputs
%  t         (1,:)  Time series (u)
%  u         (1,:)  Units string Time = (units)
%  s         (1,:)  Units string

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function [t, c, s] = TimeLabel( t )

secInYear   = 365.25*86400;
secInDay    = 86400;
secInHour   =  3600;
secInMinute =    60;

tMax        = max(t);

if( tMax > secInYear )
  c = 'Time (years)';
  s = 'years';
  t = t/secInYear;
elseif( tMax > 3*secInDay )
  c = 'Time (days)';
  t = t/secInDay;
  s = 'days';
elseif( tMax > 3*secInHour )
  c = 'Time (hours)';
  t = t/secInHour;
  s = 'hours';
elseif( tMax > 3*secInMinute )
  c = 'Time (min)';
  t = t/secInMinute;
  s = 'min';
else
  c = 'Time (sec)';
  s = 'sec';
end
