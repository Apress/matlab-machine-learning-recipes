%% Generate net training data for the digit 3
% Use a for loop to create a set of noisy images for each desired digit (between
% 0 and 9). Save the data along with indices for data to use for training. To
% create our first data set for identifying a single digit, set the digits to be
% from 0 to 5, and only set the output to 1 for the first digit. Otherwise, the
% output is 1 for the current digit. 
%
% The pixel output of the images is scaled from 0 (black) to 1 (white) so it is
% suitable for neuron activation in the neural net.

% Number of training data sets
digits     = 3;
nImagesPer = 20;

% Prepare data
nDigits   = length(digits);
nImages   = nDigits*nImagesPer;
input     = cell(1,nImages);
output    = zeros(1,nImages);
fonts     = {'times','helvetica','courier'};

% Loop
kImage = 1;
for j = 1:nDigits
  fprintf('Digit %d\n', digits(j));
  for k = 1:nImagesPer
    kFont  = ceil(rand*length(fonts)); 
    pixels = CreateDigitImage( digits(j), fonts{kFont} );
    
    % Scale the pixels to a range 0 to 1
    input{kImage} = double(pixels)/255;
    kImage        = kImage + 1;
  end
  sets = randperm(10);
end


% Use 75% of the images for training and save the rest for testing
trainSets = sort(randperm(nImages,floor(0.75*nImages)));
testSets  = setdiff(1:nImages,trainSets);

if 0 % change to 1 to save a new mat-file
  save('digit3.mat', 'input', 'trainSets', 'testSets');
end

