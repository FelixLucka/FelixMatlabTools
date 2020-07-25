function [Fx, grad] = exampleFGrad(A, x, b)

Fx   = 0.5 * sumAll((A * x - b).^2);
grad = A' * (A * x - b); 

end