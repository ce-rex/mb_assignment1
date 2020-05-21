function [data_reconstructed] = reconstruction(eigenvectors, input_vector, mean_orig)
%RECONSTRUCTION Summary of this function goes here
%   Detailed explanation goes here
data_reconstructed = eigenvectors * input_vector + mean_orig;
end

