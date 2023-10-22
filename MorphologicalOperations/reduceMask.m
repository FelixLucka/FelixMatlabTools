function a = reduceMask(a, fac)
%REDUCEMASK thins a logical mask for illustration purposes
%
% DETAILS:
%   reduceMask.m does a heuristic random search over a binary mask and removes
%   true pixels until a certain fraction of the total number of true pixels is
%   removed. It first removes pixels that have a lot of neighbours that are
%   true. This should keep the outlines of the mask intact
%
% USAGE:
%   a = reduceMask(a, 0.2)
%
% INPUTS:
%   a   - a binary mask 
%   fac - the fraction of pixels that should remain after thinning 
%
% OUTPUTS:
%   a - the thinned mask
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 17.12.2021
%       last update     - 17.12.2021
%
% See also

dim             = ndims(a);
sz_a            = size(a);

n_true          = nnz(a);
n_aim           = n_true * fac;

while(n_true > n_aim)
        
    % count how many true neighbour voxels each location has
    neighbour_count         = convn(a, ones(3 * ones(1, dim)), 'same');
    neighbour_count(not(a)) = 0;
    
    % figure out where the voxels with most neighbours are
    neighbour_max   = neighbour_count == max(neighbour_count(:));
    
    % run over image in random fashion and set some to zero
    run_order = randperm(numel(a));
    for ind=run_order
        if(neighbour_max(ind))
            
            % set entry to 0
            a(ind) = false;
            n_true = n_true - 1;
            
            % reduce neighbour count in voxels around
            switch dim
                case 2
                    [ind_1,ind_2] = ind2sub(sz_a, ind);
                    for i = max(1,ind_1-1):min(ind_1+1, sz_a(1))
                        for j = max(1,ind_2-1):min(ind_2+1, sz_a(2))
                            neighbour_count(i,j) = neighbour_count(i,j) - 1;
                            neighbour_max(i,j)   = false;
                        end
                    end
                case 3
                    [ind_1,ind_2, ind_3] = ind2sub(sz_a, ind);
                    for i = max(1,ind_1-1):min(ind_1+1, sz_a(1))
                        for j = max(1,ind_2-1):min(ind_2+1, sz_a(2))
                            for k = max(1,ind_3-1):min(ind_3+1, sz_a(3))
                                neighbour_count(i,j,k) = neighbour_count(i,j,k) - 1;
                                neighbour_max(i,j,k)   = false;
                            end
                        end
                    end
            end
            
            if(n_true <= n_aim)
                return
            end
        end
    end
end

end