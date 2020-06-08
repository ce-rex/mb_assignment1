close all;
clc;

% Defines and adds data path
data_path = "beispiel_pca_material";
addpath(data_path);
providedFunctions_path = "providedFunctions";
addpath(providedFunctions_path);

% Load data
handdata = load('handdata.mat');

%% shape model

% code

%% feature extraction

orig_image = cell2mat(handdata.images(1));
figure();
imshow(orig_image);
feature_matrix = computeFeatures(orig_image);

% Changes row vectors of features to matrix
gray_values = vec2mat(feature_matrix(1,:), size(orig_image, 2));
gradient_x = vec2mat(feature_matrix(2,:), size(orig_image, 2));
gradient_y = vec2mat(feature_matrix(3,:), size(orig_image, 2));
gradient_strength = vec2mat(feature_matrix(4,:), size(orig_image, 2));
hl_image = vec2mat(feature_matrix(5,:), size(orig_image, 2));
hl_gradient_strength = vec2mat(feature_matrix(6,:), size(orig_image, 2));
coord_x = vec2mat(feature_matrix(7,:), size(orig_image, 2));
coord_y = vec2mat(feature_matrix(8,:), size(orig_image, 2));

figure();
imagesc(gray_values);
axis equal
title('Gray Values');

figure();
imagesc(gradient_x);
axis equal
title('X Gradient');

figure();
imagesc(gradient_y);
axis equal
title('Y Gradient');

figure();
imagesc(gradient_strength);
axis equal
title('Gradient Strength');

figure();
imagesc(hl_image);
axis equal
title('Haar-like Features of Gray-Scale Image');

figure();
imagesc(hl_gradient_strength);
axis equal
title('Haar-like Features of Gradient Strength');

figure();
imagesc(coord_x);
axis equal
title('X-Coordinates');

figure();
imagesc(coord_y);
axis equal
title('Y-Coordinates');

%% classification & feature selection

% code

%% shape particle filters

% (a)

% (b) create cost function

sample31_mask = cell2mat(handdata.masks(31));
sample31_landmark = cell2mat(handdata.landmarks(31));



% (c)

% (d)

