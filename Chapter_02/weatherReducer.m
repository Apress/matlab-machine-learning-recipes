%% WEATHERREDUCER Example of using mapreduce with text files
% The are a number of weather data files in the Weather folder. We use mapreduce
% to perform a simple analysis on the event categories for each year,
% calculating the number of snow days and finding the years with the minimum and
% maximum number in our data set.
%% Form
% data = weatherReducer
%
%% Inputs
% None
%
%% Output
% data   (:)   A table of outputs, one for each keyword
%
%% See also:
% weatherReducer>weatherEventMapper
% weatherReducer>weatherProcessor

function data = weatherReducer

pHere = fileparts(mfilename('fullpath'));

tds       = tabularTextDatastore(fullfile(pHere,'/Weather'));
tds.TreatAsMissing = 'T';
tds.MissingValue = 0;
snowDays  = mapreduce(tds, @weatherEventMapper, @weatherProcessor);
data      = readall(snowDays);

function weatherEventMapper(data, info, intermediateStore)
% weatherEventMapper(data, info, intermediateStore)
% Use regexp to search the Events field of each day's stored weather data to
% locate snow days. Store the logical array as keyed data.
%
% data      Single table with dates and weather variables from one file
% info  (.) includes filename and filesize.
%  intermediateStore   The intermediate values datastore

snows = regexp(data.Events,'Snow','match');
isDay = ~cellfun(@isempty,snows);

add(intermediateStore, 'SnowDays',	struct('Filename',info.Filename,'Val',isDay));

function weatherProcessor(key, intermediateIter, outputStore)
% weatherProcessor(key, intermediateIter, outputStore) 
% Iterate over the intermediate values and perform a computation. In this case, 
% find the minimum and maximum values for the number of days with recorded snow.

maxVal = 0;
maxFilename = '';
minVal = 365;
minFilename = '';
while hasnext(intermediateIter)
  value = getnext(intermediateIter);
  
  nDays = length(find(value.Val));

  % Compare values to find the minimum
  if nDays > maxVal
      maxVal = nDays;
      maxFilename = value.Filename;
  end
  if nDays < minVal
      minVal = nDays;
      minFilename = value.Filename;
  end
end

% Add final key-value pair
add(outputStore, ['Maximum ' key], maxVal);
add(outputStore, ['Minimum ' key], minVal);
add(outputStore, ['Max Year ' key], maxFilename);
add(outputStore, ['Min Year ' key], minFilename);