function [clim, scaling]  = determineClim(data, para)
% DETERMINECLIM returns clim values to be used for plotting
%
% DESCRIPTION:
%   determineClim.m offers different ways to derive clims used for scaling data
%   before plotting 
%
% USAGE:
%  [clim,scaling]  = determineClim(data,para)
%  clim  = determineClim(data)
%
%  INPUTS:
%   data   - data that is to be plotted by another function
%   para   - a struct containing optional parameters
%       'clim'   - if clim is set it will be used as scaling without further
%       modifications 
%       'nonNeg' - logical if the data should be non-negative. If true, the
%       data will only be scaled, not shifted and clim(1) = 0
%       'noShift' - logical indicating whether the scaling should only
%                   perform scaling, no shift (0 remains invariant, default: true)
%       'histCutOff' - instead of using min(data) and max(data) to scale,
%       percentiles of the histogram will be used to scale the data, i.e.,
%       extreme values will not influence the scaling. histCutOff sets the
%       percentage of extreme values not to be used to determine the
%       scaling (default = 0, i.e., all data will be used)
%       'vector' - a logical indicating whether the input data is a
%                       vector field. For vector fields, the last
%                       dimension is assumed to index the different
%                       vector components and the scaling will be based
%                       on the amplidute of the vectors, only

%       
%  OUTPUTS:
%   clim    - the limits of the data, to be used to scale the data by
%             scaled_data = (data - clim(1))/(clim(2) - clim(1));
%   scaling - string specifying the name of the scaling.
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 14.10.2023
%
% See also data2RGB

% check user defined value for para, otherwise assign default value
if(nargin < 2)
    para = [];
end

% check if user defined clims manually
[clim, df] = checkSetInput(para, 'clim', 'numeric', [-1, 1]);

if(~df)
    scaling = 'man';
    return
elseif(isempty(data) || not(any(data(:))))
    % default, used if all the data is 0
    clim = [-1 1];
    scaling = 'auto';
    return
else
    scaling = 'auto';
end
    
% check for vector valued data
data_type = checkSetInput(para, 'dataType', {'scalar', 'vector', '2dim'}, 'scalar');
switch data_type
    case 'vector'
    % reduce to amplidute of the vectors
    data      = sqrt(sum(data.^2, ndims(data)));
    case '2dim'
        clim = zeros(2,2);
        scaling = cell(2,1);
        para_1dim                = para;
        para_1dim.dataType       = 'scalar'; 
        [clim(1,:), scaling{1}]  = determineClim(sliceArray(data, ndims(data), 1, true), para_1dim);
        [clim(2,:), scaling{2}]  = determineClim(sliceArray(data, ndims(data), 2, true), para_1dim);
        return
end

% check for histCutOff, NonNeg and noShift
hist_cutoff = checkSetInput(para, 'histCutOff', '>=0', 0);
non_neg     = checkSetInput(para, 'nonNeg', 'logical', false);
no_shift    = checkSetInput(para, 'noShift', 'logical', false);

% check for negative data
if(non_neg && any(data(:) < -eps))
    error('non negative scaling requires non-negative data!')
end


% switch between normal and hist cut off scaling
if(hist_cutoff)
    
    % based on the histogram, outliers are detected and the color scale is build from the remaining values
    scaling = [scaling, 'H'];
    aux     = sort(data(~isinf(data(:))));
    max_ind  = floor((1 - hist_cutoff) * numel(aux));
    clim    = [0 aux(max_ind)];
    if(isequal(clim,[0,0]))
        clim = [0, aux(end)];
    end
    if(non_neg)
        scaling = [scaling, 'NN'];
        return
    else
        min_ind    = ceil(hist_cutoff * numel(aux));
        clim(1)   = aux(min_ind);
        if(isequal(clim,[0,0]))
            clim = [aux(1), aux(end)];
        end
    end
    clear aux
else
    
    % min/max scaing
    clim = [0, max(data(~isinf(data(:))), [], 'omitnan')];
    if(non_neg)
        scaling = [scaling, 'NN'];
        return
    else
        clim(1) = min(data(~isinf(data(:))), [], 'omitnan');
    end
    
end

if(no_shift)
    clim = max(abs(clim)) * [-1, 1];
    scaling = [scaling, 'NS'];
end

end