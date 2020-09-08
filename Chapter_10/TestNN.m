%% Test a neural net using random weights
%
%% Description
% Test the neural net software with a picture. Use the built in random
% weights. Loads the images in the 'Cats' directory.

p           = mfilename('fullpath');
c0          = cd;
cd(fileparts(p));

folderPath = fullfile('..','Cats');

[s, name]   = ImageArray( folderPath, 4 );
d           = ConvolutionalNN;

% We use the last cat picture for the test
[d, r]      = ConvolutionalNN( 'random', d, s{end} );

fprintf(1,'Image %s has a %4.1f%% chance of being a cat\n',name{end},100*r);

cd(c0);