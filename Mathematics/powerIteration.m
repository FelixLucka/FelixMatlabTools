function [L, info, eigenvector_est] = powerIteration(A, sz_x, tol, n_rand_vec, ...
    output, type, stochastic_operator, burn_in)
% POWERITERATION approximates the largest eigenvalue of A by the
% Von Mises power iteration with multiple initilizations
%
% DESCRIPTION:
%       powerIteration computes the largest eigenvector of a positive
%       definate symetric matrix A by the power iteration
%       (https://en.wikipedia.org/wiki/Power_iteration)
%       It supports stochastic operators, in which it returns a progressig
%       average of the estimates for the largest eigenvector. Note that
%       the stochastic operator feature is experimental
%
% USAGE:
%  [L,info] = powerIteration(A, sz_x)
%  [L,info] = powerIteration(A, sz_x, tol)
%  [L,info] = powerIteration(A, sz_x, tol, n_rand_vec)
%  [L,info] = powerIteration(A, sz_x, tol, n_rand_vec, true, 'double', true)
%
%  INPUTS:
%   A   - function handle to the matrix vector product with a positive
%           definite symmetric A. In case it is a stochastic operator, it
%           needs an additional integer input that can be used to set the random seed
%           and will be used as A(x, iter) during the iteration
%   sz_x - the size of x as an input to A
%
% OPTIONAL INPUTS:
%   tol      - the iteration will derminate once the realtive change in
%              is below this tolerance value (default = 10^-3)
%   n_rand_vec - how many random initialization to try (default = 1)
%   output   - logical controlling whether the progress is printed
%              (default = false)
%   type     - numerical class of x 'double' or 'single'
%   stochastic_operator - logical indicating whether A is a stochastic
%               operator. If true, the chain |A x_i|_2 / |x_i|_2
%               will be progressively averaged to produce the largest
%               eigenvalue estimate using the weighing w_i = i for all i
%               larger than the burn_in period (see below) and w_i = i .*
%               1/(i_max - burn_in) for all i <= burn_in (i_max is the
%               current iteration count)
%   burn_in -   see above
%
%
%  OUTPUTS:
%   L    - an approximation to the largest eigenvalue of (the expected value of) A
%   info - information about the iteration as a struct
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 16.03.2017
%       last update     - 21.10.2023
%
% See also normest, condest


% check user defined value for tol, otherwise assign default value
if(nargin < 3 || isempty(tol))
    tol = 10^-3;
end

% check user defined value for nRandVec, otherwise assign default value
if(nargin < 4 || isempty(n_rand_vec))
    n_rand_vec = 1;
end

% check user defined value for output, otherwise assign default value
if(nargin < 5 || isempty(output))
    output = true;
end

% check user defined value for type, otherwise assign default value
if(nargin < 6 || isempty(type))
    type = 'double';
end

% check user defined value for type, otherwise assign default value
if(nargin < 7 || isempty(stochastic_operator))
    stochastic_operator = false;
end

% check user defined value for type, otherwise assign default value
if(nargin < 8 || isempty(burn_in))
    burn_in = 5;
end


% display information about the progress of the iteration


if(~stochastic_operator)
    A_ext = @(x, iter) A(x);
    myDisp('starting power iteration to approximate eigenvector', output);
else
    A_ext = @(x, iter) A(x, iter);
    myDisp('starting stochastic power iteration to approximate eigenvector', output);
end
L = zeros(n_rand_vec, 1);

power_iter_val = cell(n_rand_vec, 1);

t_clock = tic;
for i_rnd_vec = 1:n_rand_vec

    % display information about the progress of the iteration
    myDisp(['random vector ' int2str(i_rnd_vec) '/' int2str(n_rand_vec)],  output)

    iter = 0;

    % randomly generate a start vector for the iteration
    eigenvector_app = randn(sz_x, type);
    % normalize
    eigenvector_app = eigenvector_app ./ norm(eigenvector_app(:));

    eigenvalue_app        = 0;
    eigenvalue_app_old    = 0;
    eigenvalue_app_change = Inf;
    if(nargout > 2)
        eigenvector_est = zeros(sz_x, type);
    end

    % if numerical instabilities occur or the tolerance is reached, break
    while(abs(eigenvalue_app_change / eigenvalue_app) > tol)

        iter = iter + 1;

        % compute y = A * x
        x_new           = A_ext(eigenvector_app, iter);

        eigenvalue_new  = sum(x_new(:) .* eigenvector_app(:));
        eigenvector_app =  x_new ./ norm(x_new(:));
        power_iter_val{i_rnd_vec}(iter) = eigenvalue_new;

        if(~stochastic_operator)
            eigenvalue_app_change = eigenvalue_new - eigenvalue_app_old;
            eigenvalue_app        = max(eigenvalue_app, eigenvalue_new);
            eigenvalue_app_old    = eigenvalue_new;
            if(nargout > 2)
                eigenvector_est   = eigenvector_app;
            end
        else
            % apply progressive averaging
            eigenvalue_app_old    = eigenvalue_app;
            weights               = (1:iter);
            if(iter > burn_in)
                weights(1:burn_in) = (1:burn_in) .* 1/(iter - burn_in);
            end
            eigenvalue_app        = sum(power_iter_val{i_rnd_vec} .* weights) / sum(weights);
            eigenvalue_app_change = eigenvalue_app - eigenvalue_app_old;
            if(nargout > 2)
                eigenvector_est = eigenvector_est + eigenvector_app;
            end
        end

        % generate string with information to display
        output_str = ['it ' int2str(iter) ', rnd vec ' int2str(i_rnd_vec) ...
            ', eigenvalue est: ' num2str(eigenvalue_app ,'%.4e') ...
            '; rel change: ' num2str(eigenvalue_app_change / eigenvalue_app, '%.4e')];

        % display information about the progress of the iteration
        myDisp(output_str, output, true)

    end

    L(i_rnd_vec) = eigenvalue_app;

end
t_comp = toc(t_clock);

L = double(L);
if(~stochastic_operator)
    L = max(L);
else
    L = mean(L);
end

if(nargout > 2)
    eigenvector_est = eigenvector_est/iter;
end

% gather information about the result
info.tol               = tol;
info.t_comp            = t_comp;
info.n_nand_vec        = n_rand_vec;
info.power_iter_values = power_iter_val;

end
