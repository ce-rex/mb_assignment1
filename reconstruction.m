function [data_reconstructed] = reconstruction(eigenvectors, input_vector, mean_orig)
% Reconstruction of projected input vector
%   eigenvectors: eigenvectors used for projection
%   input_vector: projected vector
%   mean_orig: mean of data vector before projection

data_reconstructed = eigenvectors * input_vector + mean_orig;
end

