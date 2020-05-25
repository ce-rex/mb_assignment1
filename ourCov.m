function C = ourCov(D)
% Calculates the covariance matrix of D

% Number of data points
n = size(D,1);

% Ones-vector of length n
one_vector = ones(1, n);

% Calculates the mean of each column
% (one_vector * D) calculates the sum of each column
d_mean = (one_vector * D) / n;

% The mean of a column is substracted from the corresponding column 
D_substract_mean = D - d_mean(one_vector, :);

% Calculates the covariance matrix
C = (D_substract_mean.' * D_substract_mean) / (n - 1);

end