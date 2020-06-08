function [transformed_shape] = generateShape(b, eigvec, meanShape, r, s, x, y)
%GENERATESHAPE takes a parameter vector b as input and computes new shapes, where the length of b indicates the number of Eigenvectors to be considered for shape generation
%   b = parameter vector
%   eigvec = eigenvectors (N x N)
%   meanShape = mean shape (N x 1)
%   r = rotation angle in degrees
%   s = scaling factor
%   x = translation distance on x-axis
%   y = translation distance on y-axis

n_parameters = length(b);
shapeLength = length(meanShape);

% generate shape
generated_shape = reconstruction(eigvec(:,1:n_parameters), b, meanShape);

% reshape into 2-dimensional array
generated_shape = reshape(generated_shape, shapeLength/2, 2);

% create scaling matrix
scaleMat = [s 0; 0 s];
% create rotation matrix
rotMat = [ cosd(r) -sind(r); sind(r) cosd(r)];
% create translation matrix
transMat = [x; y];

% apply matrix transformations on generated_shape
transformed_shape = (rotMat * scaleMat * generated_shape' + transMat)';
end

