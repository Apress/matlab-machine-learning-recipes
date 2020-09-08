%% Example of using data from data files.
% There are a number of weather data files in the Weather folder. Demonstrates the
% use of a tabular text datastore.
% See also: FFTEnergy, PlotSet

c0 = cd;
p = mfilename('fullpath');
cd(fileparts(p));
secInDay = 86400;


%% Create the datastore from the directory of files
tDS                       = tabularTextDatastore('./Weather/');
tDS.SelectedVariableNames = {'EST','MaxTemperatureF'};

preview(tDS)
z = readall(tDS);

% The first column in the cell array is the date. year extracts the year
y     = year(z{:,1});
k1993 = find(y == 1993);
k2015 = find(y == 2015);
tSamp = secInDay;
t     = (1:365)*tSamp;
j     = {[1 2]};

%% Plot the FFT

% Get 1993 data
d1993     = z{k1993,2}';
m1993     = mean(d1993);
d1993     = d1993 - m1993;

e1993     = FFTEnergy( d1993, tSamp );

% Get 2015 data
d2015     = z{k2015,2}';
m2015     = mean(d2015);
d2015     = d2015 - m2015;
[e2015,f] = FFTEnergy( d2015, tSamp );

lG = {{sprintf('1993: Mean = %4.1f deg-F',m1993) sprintf('2015: Mean = %4.1f deg-F',m2015)}};

PlotSet(t,[d1993;d2015],  'x label', 'Days', 'y label','Amplitude (deg-F)',...
  'plot title','Temperature', 'figure title', 'Temperature','legend',lG,'plot set',j);

PlotSet(f,[e1993';e2015'],'x label', 'Rad/s','y label','Magnitude',...
  'plot title','FFT Data', 'figure title', 'FFT','plot type','ylog','legend',lG,'plot set',j);

cd(c0);
