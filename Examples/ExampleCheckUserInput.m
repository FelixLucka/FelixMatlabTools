%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the use of the functions is CheckUserInput/
%
%
% ABOUT:
% 	author          - Felix Lucka
% 	date            - 19.12.2018
%  	last update     - 19.12.2018
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ccc

%% checkSetInput is the main function that checks given fields in a struct 
% and sets them to default values

para    = [];
% length will be set to default value as there is no field in para called
% 'length'
length  = checkSetInput(para, 'length', '>0', 2)

% this will produce an error as length has to be greater than 0
para.length = -1;
length  = checkSetInput(para, 'length', '>1', 2)

% this will produce an error as test has to be of type single
para.test = double(1);
overwrite = checkSetInput(para,'test','single',1)

% this will produce an error as color has to be either 'red' or 'green'
para.color = 'blue';
color      = checkSetInput(para,'color',{'red','green'},'red')

% this will produce an error as para does not have a field called
% 'importantParameterA'
A = checkSetInput(para,'importantParameterA',[1,2,3], [], 'error')

% this will promt the user to enter the value for A as para does not have a 
% field called 'importantParameterA' and set it to 1 if the users presses
% enter
A = checkSetInput(para,'importantParameterA',[1,2,3], 1, 'promt')

% this will promt the user to enter the value for A as para does not have a 
% field called 'importantParameterA' and continue to prmot if the users presses
% enter
A = checkSetInput(para,'importantParameterA',[1,2,3], 'again', 'promt')

%% chooseInput promts the user to make a choice

% choose a logical
truth  = chooseInput('Is this funny?', 'logical', [], false)

% choose a positive numerical
time   = chooseInput('Choose the duration in second!', 'numerical', '>0', 'again')

% choose a vector
a      = chooseInput('Choose a 3x1 vector with arbitrary entries!', 'numerical', 'double', randn(3,1))

% choose an integer between 1 and 10
i      = chooseInput('Choose an integer between 1 and 10!','numerical', 1:10, 'error')

% choose a string from a set
season = chooseInput('What is your favorite season of the year?', 'string', ...
    {'spring','summer','fall','winter'}, 'again')

%% chooseFile and chooseSubDir can be used to promt the user to specify dirs and files

% choose a subfolder of the toolbox
subDir = chooseSubDir(pwd)

% choose a file in that subfolder
choice = chooseFile([pwd filesep subDir], '*.m')

