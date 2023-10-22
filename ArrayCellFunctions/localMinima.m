function [indices, v] = localMinima(V)
%LOCALMINIMA returns the local minima in an input array V
%
% DESCRIPTION:
%   localMinima.m scans the input array and returns the indices of
%   all entries who have lower values than their neighbours
%
% USAGE:
%   [indices, v] = localMinima(V)
%
% INPUTS:
%   V - a multidimensional array
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%
%
% OUTPUTS:
%   indices - indices of the local minima as [i1, j1, k1; i2, j2, k2; ...]
%   v       - vector of corresponding values of V
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 13.04.2018
%       last update     - 17.12.2018
%
% See also min, max, cumMinMax

dim     = nDims(V);
indices = [];
v       = [];

switch dim
    case 1
        
        nhInd = [-1; 1];
        
        % sweep over vector and store all sites where left and right
        % neighbour are larger
        for i=2:length(V)-1
            % check neigbours
            if(all(V(i + nhInd) >= V(i)))
                indices = [indices; i];
                v       = [v; V(i)];
            end
        end
        
    case 2
        
        nhInd = [-1 -1; -1 0; -1 1; 0 -1; 0, 1; 1 -1; 1 0; 1 1];
        
        % sweep over array and store all sites where all pixels in 9
        % neighbourhood have larger value
        for i=2:size(V,1)-1
            for j=2:size(V,2)-1
                % check neigbours
                linIndices = sub2ind(size(V), i + nhInd(:,1), j + nhInd(:,2));
                if(all(V(linIndices) >= V(i, j)))
                    indices = [indices; i, j];
                    v       = [v; V(i, j)];
                end
            end
        end
        
    case 3
        
        nhInd = [-1 -1 -1; -1 -1  0; -1 -1  1; -1  0 -1; -1  0  0; -1  0  1; ...
            -1  1 -1; -1  1  0; -1  1  1;  0 -1 -1;  0 -1  0;  0 -1  1; ...
            0  0 -1;  	      0  0  1;  0  1 -1;  0  1  0;  0  1  1; ...
            1 -1 -1;  1 -1  0;  1 -1  1;  1  0 -1;  1  0  0;  1  0  1; ...
            1  1 -1;  1  1  0;  1  1  1];
        
        % sweep over array and store all sites where all voxels in 27
        % neighbourhood have larger value
        for i=2:size(V,1)-1
            for j=2:size(V,2)-1
                for k=2:size(V,3)-1
                    % check neigbours
                    linIndices = sub2ind(size(V), i + nhInd(:,1), j + nhInd(:,2), k + nhInd(:,3));
                    if(all(V(linIndices) >= V(i, j, k)))
                        indices = [indices; i, j, k];
                        v       = [v; V(i, j, k)];
                    end
                end
            end
        end
        
    otherwise
        notImpErr
end

end