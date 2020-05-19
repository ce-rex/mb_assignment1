function [error] = reconstructEval(U, dataset, meanVector)
% INPUT
% U ... basis
% dataset ... training or test set
% meanVector ... mean vector calculated from training set

% OUTPUT
% error ... vector with error per sample for all possible basis (all eigenvectors -> 1 eigenvector)

n = size(dataset,2); % size of dataset
m = size(U,2); % number of eigenvectors
error = zeros(1, size(U,2)-1);

for j = 39 : -1 : 0
    errorBuffer = 0;
    for i = 1 : n
        coefficients = U(:,1:m-j)'*(dataset(:,i)-meanVector);
        reconstruction = (pinv(U(:,1:m-j)') * coefficients) + meanVector;
        errorBuffer = errorBuffer + sqrt(sum((dataset(:,i)-reconstruction).^2));
    end
    error(m-j) = errorBuffer / n;
end
end

