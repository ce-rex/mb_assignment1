function [data_projected] = projection(eigenvectors, input_vector)
%PROJECTION Summary of this function goes here
%   Detailed explanation goes here
m = mean(input_vector, 2)
data_projected = eigenvectors' * (input_vector - mean(input_vector, 2));
end

