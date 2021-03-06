function [feature_matrix] = computeFeatures(image)
%COMPUTEFEATURES Calculates several features for the input image and returns
% a matrix with dimension n_features x n_pixels
%   Calculated features: gray value of a pixel, gradient (x and y
%   direction), gradient strength, x- and
%   y-coordinates of the pixel, Haar-like features on the gray scale
%   image and Haar-like features on the gradient strength

% Convert image to double (necessary for some calculations)
image_gv = im2double(image);

% Gradient calculation (x and y direction)
[gradient_x, gradient_y] = gradient(image_gv);

% Gradient magnitude and gradient direction
[gradient_strength, gradient_dir] = imgradient(image_gv);

% Haar-like features calculated on gray scale image and transformation to matrix
hl_image_vec = computeHaarLike(image_gv);
hl_image = reshape(hl_image_vec(1,:)',[], size(image_gv,2));

% Haar-like features calculated on gradient strength and transformation to matrix
hl_gradient_vec = computeHaarLike(gradient_strength);
hl_gradient = reshape(hl_gradient_vec(1,:)',[],size(image_gv,2));

% Saves features in rows of feature matrix
for i=1:size(image_gv, 1)
    % Gray values
    feature_matrix(1,((i-1)*size(image_gv,2)+1):(i*size(image_gv,2)))=image_gv(i,:);
    % Gradient in x direction
    feature_matrix(2,((i-1)*size(image_gv,2)+1):(i*size(image_gv,2)))=gradient_x(i,:); 
    % Gradient in y direction
    feature_matrix(3,((i-1)*size(image_gv,2)+1):(i*size(image_gv,2)))=gradient_y(i,:); 
    % Gradient strength
    feature_matrix(4,((i-1)*size(image_gv,2)+1):(i*size(image_gv,2)))=gradient_strength(i,:); 
    % X coordinate
    feature_matrix(5,((i-1)*size(image_gv,2)+1):(i*size(image_gv,2)))= 1:1:size(image_gv,2);
    % Y coordinate
    feature_matrix(6,((i-1)*size(image_gv,2)+1):(i*size(image_gv,2)))=i*ones(1, size(image_gv,2));
   
end

% Haar-like features of the gray scale image
feature_matrix = [feature_matrix; hl_image_vec];
% Haar-like features of the gradient strength
feature_matrix = [feature_matrix; hl_gradient_vec];

end

