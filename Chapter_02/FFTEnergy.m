%% FFTENERGY Compute the energy in a signal using fft.
%% Form:
%   [e, w] = FFTEnergy( y, tSamp )
%
%% Description
% Compute the energy in a signal. y may be entered by column or row, but the
% longest dimension will be assumed to be the variation by time. The function
% computes the resolution. Creates a plot if there are no outputs.
%
%% Inputs
%   y             (:,n) Sequence
%   tSamp         (1,1) Sampling period
%
%% Outputs
%   e                   Energy
%   w                   Frequencies (rad/sec)        

function [e, w] = FFTEnergy( y, tSamp )

% Demo
if( nargin < 1 )
  Demo;
  return;
end

[n, m] = size( y );

if( n < m )
  y = y';
end

n = size( y, 1 );

% Check if an odd number and make even
if(2*floor(n/2) ~= n )
  n = n - 1;
  y = y(1:n,:);
end

x  = fft(y);
e  = real(x.*conj(x))/n;

hN = n/2;
e  = e(1:hN,:);
r  = 2*pi/(n*tSamp);
w  = r*(0:(hN-1));

if( nargout == 0 )
  tL = sprintf('FFT Energy Plot: Resolution = %10.2e rad/sec',r);
	PlotSet(w,e','x label','Frequency (rad/sec)','y label', 'Energy','plot title', tL,'plot type', 'xlog', 'figure title', 'FFT');
  clear e
end

function Demo
%% Demo
tSamp   = 0.1;
omega1  = 1;
omega2  = 3;
t       = linspace(0,1000,10000)*tSamp;
y       = sin(omega1*t) + 2*sin(omega2*t);

PlotSet(t,y,'x label', 'Time (s)', 'y label','Amplitude','plot title','FFT Data', 'figure title', 'FFT Data');
FFTEnergy( y, tSamp );
