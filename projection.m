function [data_projected] = projection(eigenvectors, input_vector)
% Projection of the input vector onto the eigenvector space
%   eigenvectors: eigenvectors for the projection
%   input_vector: vector that should be projected onto the new space

data_projected = eigenvectors' * (input_vector - mean(input_vector, 2));
end

