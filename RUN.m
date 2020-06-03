close all;
clc;

% Defines and adds data path
data_path = "beispiel_pca_material";
addpath(data_path);
providedFunctions_path = "providedFunctions";
addpath(providedFunctions_path);

%% shape model

data = load(data_path + "/shapes.mat");
shapes = data.aligned;

% Flatten shapes so that ourPca can process them
shapes_flattened = reshape(shapes, 256, 14);

% Perform pca on the flattened shapes
[eigval, eigvec] = ourPca(shapes_flattened);
eigval_sqrts = sqrt(eigval);

% try different parameters to use with generate_shape
b_coefficients = [
 0 1 2 -1 -2;
 2 -1 0 3 0;
 -1 2 2 -2 -2;
];
r = [0, 45, 90];
s = [1, 0.5, 3];
x = [0 50 10];
y = [0 50 -50];

figure()
title("Shapes generated based on different parameter settings");
for i = [1, 2, 3]
    
    generated_shape = generateShape(eigval_sqrts(1:5) .* b_coefficients(i, :)', r(i), s(i), x(i), y(i));

    % Plot generated shape
    subplot(1, 3, i);
    scatter(generated_shape(:, 1), generated_shape(:, 2));
end

%% feature extraction

% code

%% classification & feature selection

% code

%% shape particle filters

% code

