%% Train a neural net on the Cats images
% Trains the net from the images in the Cats folder. Many thousands of
% function evaluations are required for meaningful training, but allowing just a
% few shows that the function is working.
%% See also:
% ImageArray, ConvolutionalNN

p  = mfilename('fullpath');
c0 = cd;
cd(fileparts(p));

folderPath = fullfile('..','Cats');
[s, name]  = ImageArray( folderPath, 4 );
d          = ConvolutionalNN;

% Use all but the last for training
s = s(1:end-1);

% This may take awhile
% Use at least 10000 iterations to see a higher change of being a cat!
disp('Start training...')
d.opt.Display = 'iter';
d.opt.MaxFunEvals = 500;
d =	ConvolutionalNN( 'train', d, s );

% Test the net using the last image that was not used in training
[d, r] = ConvolutionalNN( 'test', d, s{end} );

fprintf(1,'Image %s has a %4.1f%% chance of being a cat\n',name{end},100*r);

% Test the net using the first image
[d, r] = ConvolutionalNN( 'test', d, s{1} );

fprintf(1,'Image %s has a %4.1f%% chance of being a cat\n',name{1},100*r);

cd(c0);
