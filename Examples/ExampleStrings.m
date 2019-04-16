%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the use of the functions is Strings/
%
%
% ABOUT:
% 	author          - Felix Lucka
% 	date            - 15.01.2019
%  	last update     - 15.01.2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ccc

%% converting bytes and seconds into human readable strings

convertBytes(1024^3) % 1024^3 bytes = 1 GB
convertSec(60 * 60) % 60*60 seconds = 1h

%% generating path and file names

%   genPathAndFilename.m takes a cell of strings or structs and constructs a
%   file path and file name from it. 

infoCell = {'ID1', 'ID2', 'ID3'}

genPara = [];

% generation parameters (see documentation)
genPara.mkDir    = false;
genPara.prefix   = 'a';
genPara.postfix  = 'b';
genPara.output   = true;
genPara.filenameSep    = '--';
genPara.pathnameSep  = '\';
genPara.sepAtEnd = true;

[path, ~, filename] = genPathAndFilename(infoCell, genPara)

%% modifications of num2str and its variants 

% num2strEdelZero removes the 0's from the output of num2str(a, precisionStr)
% after the exponential sign: '1.00e-01' --> '1.00e-1'

num2str(10, '%.2e')
num2strEdelZero(10, '%.2e')

% int2strLead0 converts an integer to a string but attaches 0s in front to 
% obtain a predefined total number of digits
int2strLead0(123, 6)

%% basic string manipulation functions

% upperFirst just capitalizes the first letter
upperFirst('felix')

% removeDoubleCharacter deletes all appearances of the same character in a
% row
removeDoubleCharacter('abvaaabca', 'a')

% removeLeadTailCharacter deletes all appearances of a character in at the
% begining or tail of a string
removeLeadTailCharacter('abvaaabca', 'a')

% removeDoubleLeadTailCharacter removes all instances of the same character in a
% row and deletes it from begining and end
removeDoubleLeadTailCharacter('abvaaabca', 'a')

% repetitionLenght figures out if an input sequence is the repetiton of a 
% smaller sub-sequence and returns the length of this sequence
repLength = repetitionLenght('abcabcabc')
