function CLIPS
%% CLIPS expert system shell
% It requires a rules file ules.CLP
% It uses the dynamic library libCLIPS.dylib that must be in the same
% folder.
% form result = CLIPS(facts)
% where facts is a string of facts of the form
% '(wheel-turning no) (power yes) (torque-command yes)'
% Each fact has a yes/no answer.

