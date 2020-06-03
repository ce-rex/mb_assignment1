function [transformed_shape] = generateShape(b, r, s, x, y)
%GENERATESHAPE takes a parameter vector b as input and computes new shapes, where the length of b indicates the number of Eigenvectors to be considered for shape generation
%   b = parameter vector
%   r = rotation angle in degrees
%   s = scaling factor
%   x = translation distance on x-axis
%   y = translation distance on y-axis

% load data
addpath('beispiel_pca_material');
data_path = "beispiel_pca_material";
data = load(data_path + "/shapes.mat");
shapes = data.aligned;

% flatten shapes to make them digestable for ourPca. yum
shapes_flattened = reshape(shapes, 256, 14);

% perform pca on the flattened shapes
[eigval, eigvec] = ourPca(shapes_flattened);

% compute mean shape
mean_coordinate = mean(shapes_flattened, 2);

n_parameters = length(b);

% generate shape
generated_shape = reconstruction(eigvec(:,1:n_parameters), b, mean_coordinate);

% reshape into 2-dimensional array
generated_shape = reshape(generated_shape, 128, 2);

% create scaling matrix
scaleMat = [s 0; 0 s];
% create rotation matrix
rotMat = [ cosd(r) -sind(r); sind(r) cosd(r)];
% create translation matrix
transMat = [x; y];

% apply matrix transformations on generated_shape
transformed_shape = (rotMat * scaleMat * generated_shape' + transMat)';
end

