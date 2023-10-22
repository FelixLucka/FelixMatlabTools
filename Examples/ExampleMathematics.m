%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the use of the functions is Mathematics/
%
%
% ABOUT:
% 	author          - Felix Lucka
% 	date            - 31.01.2019
%  	last update     - 22.10.2023
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ccc

%% factors

% factorizeInTwo tries to factor a number into two factors such that both
%are as close as possible
[a, b]  = factorizeInTwo(17*19)
[a, b]  = factorizeInTwo(2^16)


%% rounding 

% roundN rounds x to a given power of 10
roundN(pi, -1)
roundN(pi, -3)

% round2Precision rounds a number to the precision described by the precision string p.
% it uses num2str and str2double, which is NOT efficient
round2Precision(pi, '%.2d')
round2Precision(pi, 2)

%% power iteration

% powerIteration approximates the largest eigenvalue of A by the
% Von Mises power iteration with multiple initilizations
n = 100;
A = randn(n, n);
A = A' * A;

[max_eig_square, info] = powerIteration(@(x) A * x, [n, 1], 10^-12, 1, true);

max_eig_square
norm(A)

%% sorting

%insertionSort is a simple insertion sort implementation
X = randperm(100);
[X_sort, ind]   = insertionSort(X);
[X_sort2, ind2] = sort(X);

isequal(ind, ind2)

%% compute gradients

% verify that gradient of f(x) = 0.5 * |A x - b|_2^2 is given as A'*(A*x-b)
% numerically
A = randn(10,4);
x = randn(4,1);
b = randn(10,1);

% see exampleFGrad.m for the function definition
FGrad = @(x) exampleFGrad(A, x, b);

results = gradientTest(FGrad, x)
