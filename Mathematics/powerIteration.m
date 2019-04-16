function [L, info] = powerIteration(A, sizeX, tol, nRandVec, output, type)
% POWERITERATION approximates the largest eigenvalue of A by the
% Von Mises power iteration with multiple initilizations
%
% DESCRIPTION:
%       powerIteration computes the largest eigenvector of a positive
%       definate symetric matrix A by the power iteration
%       (https://en.wikipedia.org/wiki/Power_iteration)
%
% USAGE:
%  [L,info] = powerIteration(A, sizeX)
%  [L,info] = powerIteration(A, sizeX, tol)
%  [L,info] = powerIteration(A, sizeX, tol, nRandVec)
%
%  INPUTS:
%   A     - function handle to the matrix vector product with a positive 
%           definite symmetric A
%   sizeX - the size of x as an input to A
%
% OPTIONAL INPUTS:
%   tol      - the iteration will derminate once the realtive change in 
%              is below this tolerance value (default = 10^-3)  
%   nRandVec - how many random initialization to try (default = 1)
%   output   - logical controlling whether the progress is printed
%              (default = false)
%   type     - numerical class of x 'double' or 'single'
%
%  OUTPUTS:
%   L    - an approximation to the largest eigenvalue of A
%   info - information about the iteration as a struct
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 16.03.2017
%       last update     - 16.03.2017
%
% See also normest, condest


% check user defined value for tol, otherwise assign default value
if(nargin < 3 || isempty(tol))
    tol = 10^-3;
end

% check user defined value for nRandVec, otherwise assign default value
if(nargin < 4 || isempty(nRandVec))
    nRandVec = 1;
end

% check user defined value for output, otherwise assign default value
if(nargin < 5 || isempty(output))
    output = true;
end

% check user defined value for type, otherwise assign default value
if(nargin < 6 || isempty(type))
    type = 'double';
end

% display information about the progress of the iteration
if(output)
    disp('starting power iteration to approximate eigenvector');
end

L = 0;
powerIterVal = cell(nRandVec, 1);

t_clock = tic;
for iRandVec = 1:nRandVec
    
    % display information about the progress of the iteration
    if(output)
        disp(['random vector ' int2str(iRandVec) '/' int2str(nRandVec)]);
    end
    
    iIter = 0;
    
    % randomly generate a start vector for the iteration
    eigenvectorApp = randn(sizeX, type);
    % normalize
    eigenvectorApp = eigenvectorApp ./ norm(eigenvectorApp(:));
    
    eigenvalueApp        = 0;
    eigenvalueAppOld    = 0;
    eigenvalueAppChange = Inf;
    
     % if numerical instabilities occur or the tolerance is reached, break
    while(eigenvalueAppChange / eigenvalueApp > tol)
        
        iIter = iIter + 1;
        
        % compute y = A * x
        xNew           = A(eigenvectorApp);
        eigenvalueNew  = sum(xNew(:) .* eigenvectorApp(:));
        powerIterVal{iRandVec}(iIter) = eigenvalueNew;
        eigenvalueAppChange = eigenvalueNew - eigenvalueAppOld;
        eigenvalueApp = max(eigenvalueApp, eigenvalueNew);
        
        
        eigenvectorApp    =  xNew ./ norm(xNew(:));
        eigenvalueAppOld = eigenvalueNew;
        
        % generate string with information to display
        outputStr = ['it ' int2str(iIter) ', rnd vec ' ...
                     int2str(iRandVec) ', eigenvalue est: ' ...
                     num2str(eigenvalueApp,'%.4e') ...
                     '; rel change: ' ...
                     num2str(eigenvalueAppChange / eigenvalueApp,'%.4e')];
                 
        % display information about the progress of the iteration         
        if(output)
            disp(outputStr)
        end
        
    end
    
    L = max(eigenvalueApp, L);
    
end
t_comp = toc(t_clock);

L = double(L);

% gather information about the result
info.tol               = tol;
info.t_comp            = t_comp;
info.n_nand_vec        = nRandVec;
info.power_iter_values = powerIterVal;

end
