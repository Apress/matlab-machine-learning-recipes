%% CATREDUCER Use mapreduce with an ImageDatastore
% The Cats image directory must be in the parent directory.
%% Form
% data = catReducer
%
%% Description
% The are a number of pictures of cats in the Cats/ folder, for use in the image
% recognition chapter. We use mapreduce to perform a simple analysis on the
% colors of the images, which could be extended to any computation. In this
% case, we compute the average red, green, and blue values for each image; then
% we find the image with the minumum value for each of these keys.
%
%% Inputs
% None
%
%% Outputs
% data   (:)   A table of outputs, one for each key: Red, Green, Blue
%
% See also:
% catReducer>catColorMapper
% catReducer>catColorReducer

function [data,imds] = catReducer

if ~exist('Cats','dir')
  error('The Cats directory was not found on the path. Exiting.')
end

p           = mfilename('fullpath');
c0          = cd;
cd(fileparts(p));

imds = imageDatastore('../Cats');
minRGB = mapreduce(imds, @catColorMapper, @catColorReducer);
data = readall(minRGB);
disp(data)

cd(c0);

function catColorMapper(data, info, intermediateStore)
% catColorMapper(data, info, intermediateStore)
% Calculate three pieces of keyed data on each image: the average of the red,
% green, and blue values. The images have RGB arrays in the third dimension as
% (1,2,3).
%
%  data (:,:,3)        Image stored as an RGB matrix 
%  info (.)            info includes filename and filesize. 
%  intermediateStore   The intermediate values datastore

% Calculate the average (R,G,B) values
avgRed = mean(mean(data(:,:,1)));
avgGreen = mean(mean(data(:,:,2)));
avgBlue = mean(mean(data(:,:,3)));

% Store the calculated values with text keys
add(intermediateStore, 'Avg Red', struct('Filename',info.Filename,'Val', avgRed));
add(intermediateStore, 'Avg Green', struct('Filename',info.Filename,'Val', avgGreen));
add(intermediateStore, 'Avg Blue', struct('Filename',info.Filename,'Val', avgBlue));

function catColorReducer(key, intermediateIter, outputStore)
% catColorReducer(key, intermediateIter, outputStore)
% Iterate over the intermediate values and perform a computation.
% In this case, find the minimum value for each key.

% Iterate over values for each key
minVal = 255;
minImageFilename = '';
while hasnext(intermediateIter)
  value = getnext(intermediateIter);

  % Compare values to find the minimum
  if value.Val < minVal
      minVal = value.Val;
      minImageFilename = value.Filename;
  end
end

% Add final key-value pair
add(outputStore, ['Minimum - ' key], minImageFilename);
