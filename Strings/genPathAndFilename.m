function [path, pathShort, filename] = genPathAndFilename(infoCell, para)
%GENPATHANDFILENAME takes a cell of identifieres and constructs a path and a 
% filename from it 
%
% DESCRIPTION: 
%   genPathAndFilename.m takes a cell of strings or structs and constructs a
%   file path and file name from it. 
%   If all cells contain strings as in 
%   infoCell = {'ID1', 'ID2', ID3'}  it will return 
%   path = 'ID1/ID2/ID3/', pathShort = 'ID1/ID2/ID3/' and filename = 'ID1_ID2_ID3';
%   If all cells contain strucs with fields ID and IDshort as in 
%   infoCell = {s1, s2, s3} with s1.ID = Identifier1, s1.IDshort = i1, ...
%   it will return 
%   path = 'Identifier1/Identifier2/Identifier3/', 
%   pathShort = 'i1/i2/i3/' and filename = 'i1_i2_i2';
%   
%
% USAGE:
%   [path, pathShort, filename] = genPathAndFilename(infoCell, para)
%
% INPUTS:
%   infoCell - cell of strings of structs (see describtion)
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%       'mkDir' - logical determining whether the function will try to
%       create the path
%       'prefix'/'postfix' - a single string of cell of strings that will be
%       used as pre- or postfixed
%       'output' - logical indicating whether function should display
%       output
%       'filenameSep' - char used to separate parts of filename (default:
%       '_')
%       'filenameSep' - char used to separate parts of path (default:
%       char returned by filesep.m function)
%       'sepAtEnd' - logical indicating whether the path should be ended by
%       a filesep char or not (a/b/c vs a/b/c/)
%
% OUTPUTS:
%   x - bla bla
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 15.01.2019
%
% See also

% check user defined value for para, otherwise assign default value
if(nargin < 2)
    para = [];
end

% read out parameters
mkDir    = checkSetInput(para, 'mkDir', 'logical', false);
prefix   = checkSetInput(para, 'prefix', 'mixed', '');
postfix  = checkSetInput(para, 'postfix', 'mixed', '');
output   = checkSetInput(para, 'output', 'logical', false);
fnSep    = checkSetInput(para, 'filenameSep', 'char', '_'); 
pathSep  = checkSetInput(para, 'pathnameSep', 'char', filesep); 
sepAtEnd = checkSetInput(para, 'sepAtEnd', 'logical', true); 

% convert prefix into cell if not already
if(~iscell(prefix))
    prefix_     = cell(size(infoCell));
    prefix_(:)  = {prefix};
    prefix  = prefix_;
end

% convert postfix into cell if not already
if(~iscell(postfix))
    postfix_     = cell(size(infoCell));
    postfix_(:)  = {postfix};
    postfix  = postfix_;
end

%%% construct path, pathShort and filename
path      = '';
pathShort = '';
filename  = '';


for iCell = 1:length(infoCell)
    
    % attach prefix
    path      = [path      pathSep prefix{iCell}];
    pathShort = [pathShort pathSep prefix{iCell}];
    filename  = [filename  fnSep   prefix{iCell}];
    
    %%% attach ID
    
    % check if the cell contains struct or string
    if(~isstruct(infoCell{iCell}))
        if(ischar(infoCell{iCell}))
            ID = infoCell{iCell};
           infoCell{iCell} = struct('ID', ID);
        else
            error(['cell input ' int2str(iCell) ' is neither struct nor string!']);
        end
    end
    
    % attach ID to path and filename
    if(isfield(infoCell{iCell}, 'ID'))
        path = [path infoCell{iCell}.ID];
        if(isfield(infoCell{iCell}, 'IDshort'))
            pathShort = [pathShort infoCell{iCell}.IDshort];
            filename = [filename infoCell{iCell}.IDshort];
        else
            pathShort = [pathShort infoCell{iCell}.ID];
            filename = [filename infoCell{iCell}.ID];
        end
    else
        error(['info struct ' int2str(iCell) ' has not ID field!']);
    end
    
    % attach postfix
    path      = [path      postfix{iCell}];
    pathShort = [pathShort postfix{iCell}];
    filename  = [filename  postfix{iCell}];
    
end

% remove double file seps
path      = removeDoubleLeadTailCharacter(path,      pathSep);
pathShort = removeDoubleLeadTailCharacter(pathShort, pathSep);
filename  = removeDoubleLeadTailCharacter(filename,  fnSep);

% add separator at the end
if(sepAtEnd)
    path = [path pathSep];
end

% make dir
if(mkDir)
    makeDir(path, output);
end


end