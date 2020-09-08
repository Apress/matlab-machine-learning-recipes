%% Train a neural net on a single digit
% Trains the net from the images in the loaded mat file.

% Switch to use one image or all for training purposes
useOneImage = false;

% This is needed to make runs consistent
rng('default')

% Load the image data
load('digit3');

% Training
if useOneImage
  % Use only one image for training
	trainSets	= 2; 
  testSets  = setdiff(1:length(input),trainSets);
end
fprintf(1,'Training Image(s) [')
fprintf(1,'%1d ',trainSets);
fprintf(1,']\n');
d     = ConvolutionalNN;
d.opt = optimset('TolX',1e-5,'MaxFunEvals',400000,'maxiter',200000);
d     =	ConvolutionalNN( 'train', d, input(trainSets) );
fprintf(1,']\nFunction value (should be zero) %12.4f\n',d.fVal);

% Test the net using a test image
for k = 1:length(testSets)
  [d, r] = ConvolutionalNN( 'test', d, input{testSets(k)} );
  fprintf(1,'Test image %d has a %4.1f%% chance of being a 3\n',testSets(k),100*r);
end

% Test the net using a test image
[d, r] = ConvolutionalNN( 'test', d, input{trainSets(1)} );

fprintf(1,'Training image %2d has a %4.1f%% chance of being a 3\n',trainSets(1),100*r);

