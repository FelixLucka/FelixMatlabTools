function [path, path_short, filename] = genPathAndFilename(info_cell, para)
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
%   [path, path_short, filename] = genPathAndFilename(info_cell, para)
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
%   path - see descrition
%   path_short - see descrition
%   filename - see descrition
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 13.10.2023
%
% See also

% check user defined value for para, otherwise assign default value
if(nargin < 2)
    para = [];
end

% read out parameters
mk_dir     = checkSetInput(para, 'mkDir', 'logical', false);
prefix     = checkSetInput(para, 'prefix', 'mixed', '');
postfix    = checkSetInput(para, 'postfix', 'mixed', '');
output     = checkSetInput(para, 'output', 'logical', false);
fn_sep     = checkSetInput(para, 'filenameSep', 'char', '_'); 
path_sep   = checkSetInput(para, 'pathnameSep', 'char', filesep); 
sep_at_end = checkSetInput(para, 'sepAtEnd', 'logical', true); 

% convert prefix into cell if not already
if(~iscell(prefix))
    prefix_     = cell(size(info_cell));
    prefix_(:)  = {prefix};
    prefix  = prefix_;
end

% convert postfix into cell if not already
if(~iscell(postfix))
    postfix_     = cell(size(info_cell));
    postfix_(:)  = {postfix};
    postfix  = postfix_;
end

%%% construct path, pathShort and filename
path      = '';
path_short = '';
filename  = '';


for iCell = 1:length(info_cell)
    
    % attach prefix
    path      = [path      path_sep prefix{iCell}];
    path_short = [path_short path_sep prefix{iCell}];
    filename  = [filename  fn_sep   prefix{iCell}];
    
    %%% attach ID
    
    % check if the cell contains struct or string
    if(~isstruct(info_cell{iCell}))
        if(ischar(info_cell{iCell}))
            ID = info_cell{iCell};
           info_cell{iCell} = struct('ID', ID);
        else
            error(['cell input ' int2str(iCell) ' is neither struct nor string!']);
        end
    end
    
    % attach ID to path and filename
    if(isfield(info_cell{iCell}, 'ID'))
        path = [path info_cell{iCell}.ID];
        if(isfield(info_cell{iCell}, 'IDshort'))
            path_short = [path_short info_cell{iCell}.IDshort];
            filename = [filename info_cell{iCell}.IDshort];
        else
            path_short = [path_short info_cell{iCell}.ID];
            filename = [filename info_cell{iCell}.ID];
        end
    else
        error(['info struct ' int2str(iCell) ' has not ID field!']);
    end
    
    % attach postfix
    path      = [path      postfix{iCell}];
    path_short = [path_short postfix{iCell}];
    filename  = [filename  postfix{iCell}];
    
end

% remove double file seps
path       = removeDoubleLeadTailCharacter(path,      path_sep);
path_short = removeDoubleLeadTailCharacter(path_short, path_sep);
filename   = removeDoubleLeadTailCharacter(filename,  fn_sep);

% add separator at the end
if(sep_at_end)
    path = [path path_sep];
end

% make dir
if(mk_dir)
    makeDir(path, output);
end


end