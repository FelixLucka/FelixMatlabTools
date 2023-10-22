%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the use of the functions is ArrayCellFunctions/
%
%
% ABOUT:
% 	author          - Felix Lucka
% 	date            - 17.12.2018
%  	last update     - 22.10.2023
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% min, max, sum, any, diff operations
ccc

% generate 10x10x10 matrix with standard normally distributed entries
X = randn(10, 10, 10);

% sumAll(X)/minAll(X)/maxAll(X) is the same as sum(X(:))/min(X(:))/max(X(:))
isequal(sumAll(X), sum(X(:)))
isequal(minAll(X), min(X(:)))
isequal(maxAll(X), max(X(:)))

% minAll / maxAll can also return the sub-scripts of the min/max
[value, ijk] = minAll(X)
[value, ijk] = maxAll(X)

% maxAllBut/sumAll applies the max/sum function along all dimensions of A except the
% specified one
result = maxAllBut(X, 2);
isequal(result(1), max(vec(X(:,1,:))))
result = sumAllBut(X, 2);
isequal(result(1), sum(vec(X(:,1,:))))

% MinMax returns [min(X(:)), max(X(:))]
[min_X, max_X] = minMax(X)

% anyAll(X) is the same as any(X(:))
X = randn(100) > 0;
isequal(anyAll(X), any(X(:)))


X = randn(100, 1);
[cum_min_X, cum_max_X] = cumMinMax(X);
figure();
plot([X, cum_min_X, cum_max_X])

% firstNonZero projects an n-dim array onto the first non zero value
%along a specified dimension
X = randi(100, [6,6]) .* (randn(6) > 0.4)
firstNonZero(X, 1)
firstNonZero(X, 2)

% extract local minima in image
X            = randi(100, [10, 10])
[indices, v] = localMinima(X)


X = randn(10);
Y = randn(10);
isequal(maxDiff(X, Y, false), max(abs(X(:) - Y(:))))
isequal(maxDiff(X, Y, true), max(abs(X(:) - Y(:)))/max(abs([X(:);Y(:)])))

% isMonotonic checks if the values in a given vector increase monotonically 
isMonotonic([1 2 3])
isMonotonic([1 0 3])
isMonotonic([1 1], true) 
isMonotonic([1 1], false) 


%% array manipulations

X = magic(5)
% padArray is a simpler reimplementation of padarray
padArray(X, [1 1], -1, 'pre')
% cutArray cuts of columns and rows
cutArray(X, [1, 1], 'post')

% stretchVec spreads the entries of a vector into a larger vector
X = 1:3;
stretchVec(X, [1,3,7], 10, -1)

% sliceArray can be used to extract slices from an array without explicit
% indexing
X = randi(10,[2,3,2])
slices1 = sliceArray(X, 3, 2, true)
slices2 = sliceArray(X, 2, 3, true)

% sliceArray can be used to extract slices from an array without explicit
% indexing
sliceArray(X, 3, 2, true)
sliceArray(X, 2, 3, true)

% insertIntoArray can be used to insert slices into an array without explicit
% indexing
insertIntoArray(X, slices1, 3, 1)
insertIntoArray(X, slices2, 2, 1)

% vec is a wrapper for x(:)
vec(X)

%% cell functions

% repIntoCell returns a cell array of a given size with each cell containing the 
% same object
X     = magic(5)
X_cell = repIntoCell(X, [1,2])

% applyToMatOrCell applies a function handle to the input if the input is
% a numeric, or to each cell of a cell array
applyToMatOrCell(@(x) sum(x), X)
applyToMatOrCell(@(x) sum(x), X_cell)


%% modifications

% nDims is a modification of ndims that reacts a bit differently 
X = randn(10,1);
[nDims(X), ndims(X)]
X = randn(1,10);
[nDims(X), ndims(X)]
X = randn(10,1,10);
[nDims(X), ndims(X)]
[nDims(X, false), ndims(X)]

%% misc

% tableInput is a wrapper fir unique and can be used to hash inputs
X = randi(2, 10,2)
[ind, table] = tableInput(X)
[table, ~, ind] = unique(X, 'rows','last')

% castFunction returns a function handle to cast variables to a certain
%numeric type and a handle to allocate an array of a given size
[castFun, castZeros] = castFunction('single')
castFun(double(1))
castZeros(4)

% detectOverlappingIntervals checks whether given intervals overlap
detectOverlappingIntervals([1 2;3 4])
detectOverlappingIntervals([1 3;2 4])
