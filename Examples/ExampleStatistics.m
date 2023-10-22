%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the use of the functions is Statistics/
%
%
% ABOUT:
% 	author          - Felix Lucka
% 	date            - 31.01.2019
%  	last update     - 22.10.2023
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ccc

%%

% setRandomSeed sets the state of the global random stream to a given input
% or shuffles is using clock()
setRandomSeed('rand')
setRandomSeed(123)

%% random number generation

% gamRnd.m is a re-implementation of the method of Marsaglia and Tsang,
%  2000, 'A Simple Method for Generating Gamma Variables",
%  ACM Trans. Math. Soft. 26(3):363-372.
alpha = 1;
beta  = 1;
gamRnd(alpha, beta)

% sampleWeights samples a given, unnormalized distribution of weights
samples = zeros(10000,1);
for i=1:length(samples)
    samples(i) = sampleWeights(1:3);
end
figure();
hist(samples, 1:3)

%% cov2corr converts a covariance matrix to a correlation matrix

X         = randn(100,10) .* repmat(1:10, 100, 1);
cov_X     = cov(X);
corr_X    = cov2corr(cov_X);

figure();
subplot(1, 2, 1); imagesc(cov_X);
subplot(1, 2, 2); imagesc(corr_X);

%% noise generation

im = 10*phantom(100);

para = [];
para.noiseType      = 'AdditiveGaussian';
para.amplitude      = 'relativeLInf';
para.noiseParameter = 0.1 % relative standart deviation

imGaussNoise = noiseSignal(im, para);

para = [];
para.noiseType  = 'Poisson';
imPoissonNoise  = noiseSignal(im, para);

figure();
subplot(1, 3, 1); imagesc(im);
subplot(1, 3, 2); imagesc(imGaussNoise);
subplot(1, 3, 3); imagesc(imPoissonNoise);
