%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the use of the functions is ControlFlowOutput/
%
%
% ABOUT:
% 	author          - Felix Lucka
% 	date            - 16.01.2019
%  	last update     - 16.01.2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% clear, close, clc short cuts

% close all force; drawnow;
closeAll

% close all force; drawnow; clc;
cc

% clear all; close all force; drawnow; clc;
ccc


%% flow control 

% checkUnix can be used inside functions that rely on unix commands to
% check that we are on a unix system
checkUnix('functionA')

% notImpErr can be used in code branches that are opened already to
% indicate where future developments should be placed but are not complete
% yet
notImpErr

% oldImpErr can be used in code branches that are outdated and need to be
% replaced but are not deleted yet because they may contain code that is
% easier to modify then to write from scratch
oldImpErr

%% print output

% dispBlanc(n) prints n empty lines 
dispBlanc(4)

% rewindAndPrint can be used to print status updates while overwriting the
% old status
Nchar = 0;
fprintf('status: ')
for i=1:100
    Nchar =  rewindAndPrint([int2str(i) '%%'], Nchar);
    pause(1/i)
end

%% parallel pool functions

% this will first close ny old par pool, then open a new one, full output
output             = true;
deleteExistingPool = true;
pp = openParPool(2, output, deleteExistingPool);

% this will first close the old pool, then open a new one, no output
output             = false;
deleteExistingPool = true;
pp = openParPool(2, output, deleteExistingPool);

% this won't do anything, as a pool with 2 workers is open already
output             = false;
deleteExistingPool = false;
pp = openParPool(2, output, deleteExistingPool);

% this will close the pool with 2 workers and open one with 3
pp = openParPool(3, false);

% this will close the pool without output
closeParPool(pp, false)


%% script control

% pauses the execution of a script for t seconds and displays a count down 
continueComputationIn(10)

% script is stopped and an error is thrown
stopScriptErr

% script is stopped and matlab will be closed afer some seconds
exitMatlabIn(1000)

