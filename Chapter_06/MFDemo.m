%% Fuzzy membership function demo
% Specify example data for each type of membership function in the toolbox and
% create a plot using FuzzyPlot.
%% See also:
% FuzzyPlot, NewFigure, TriangleMF, GaussianMF, GeneralBellMF, SigmoidalMF,
% TrapezoidMF

fzSet = struct;

fzSet.name = 'Example of Triangle Membership Function';
fzSet.comp = {''};
fzSet.type = {'Triangle'};
fzSet.params = {[2 5]};
fzSet.range = [0 10];
NewFigure('Triangle MF');
FuzzyPlot(fzSet)

fzSet.name = 'Example of Gaussian Membership Function';
fzSet.comp = {''};
fzSet.type = {'Gaussian'};
fzSet.params = {[2 5]};
fzSet.range = [0 10];
NewFigure('Gaussian MF');
FuzzyPlot(fzSet)
text(6,0.9,'Parameter values: [2 5]')

fzSet.name = 'Example of General Bell Membership Function';
fzSet.comp = {''};
fzSet.type = {'GeneralBell'};
fzSet.params = {[2 2 5]};
fzSet.range = [0 10];
NewFigure('General Bell MF');
FuzzyPlot(fzSet)
text(7,0.9,'Parameter values: [2 2 5]')

fzSet.name = 'Example of Sigmoidal Membership Function';
fzSet.comp = {'',''};
fzSet.type = {'Sigmoidal','Sigmoidal'};
fzSet.params = {[1 6],[-0.1 3]};
fzSet.range = [0 10];
NewFigure('Sigmoidal MF');
FuzzyPlot(fzSet)
text(6.5,0.45,'Parameter values: [1 6]')
text(3,0.9,'Parameter values: [-0.1 3]')

fzSet.name = 'Example of Trapezoid Membership Function';
fzSet.comp = {''};
fzSet.type = {'Trapezoid'};
fzSet.params = {[1 3 5 7]};
fzSet.range = [0 10];
NewFigure('Trapezoid MF');
FuzzyPlot(fzSet)
text(6,0.9,'Parameter values: [1 3 5 7]')

