%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the use of the functions is Mathematics/
%
%
% ABOUT:
% 	author          - Felix Lucka
% 	date            - 31.01.2019
%  	last update     - 31.01.2019
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

[maxEigSquare, info] = powerIteration(@(x) A * x, [n, 1], 10^-12, 1, true);

maxEigSquare
norm(A)

%% sorting

%insertionSort is a simple insertion sort implementation
X = randperm(100);
[Xsort, ind]   = insertionSort(X);
[Xsort2, ind2] = sort(X);

isequal(ind, ind2)

