% first name last name, matriculation number
function [error] = calculateError(original, reconstruction)
% INPUT
% original ... ground truth data, test or training sample as in dataset
% reconstruction ... output of reconstruction with pca

% OUTPUT
% error ... reconstruction error, Euclidean distance (or MSE) between original and reconstruction

error = sqrt(sum((original-reconstruction).^2));
% or MSE
%error = sum((original-reconstruction).^2);
end

