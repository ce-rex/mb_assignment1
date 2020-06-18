close all;
clc;

% Defines and adds data path
data_path = "beispiel_pca_material";
addpath(data_path);
providedFunctions_path = "providedFunctions";
addpath(providedFunctions_path);

% Load data
handdata = load('handdata.mat');

%% 1. shape model

shapes = handdata.aligned(:,:,1:30);

% flatten shapes to make them digestable for ourPca. yum
shapes_flattened = reshape(shapes, 128, 30);
% compute mean shape
meanShape = mean(shapes_flattened, 2);
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
s = [1, 0.8, 1.3];
x = [0 20 10];
y = [0 20 -50];

figure()
labels = [];
title("Shapes generated based on different parameter settings");
for i = [1, 2, 3]
    
    generated_shape = generateShape(eigval_sqrts(1:5) .* b_coefficients(i, :)', eigvec, meanShape, r(i), s(i), x(i), y(i));

    % Plot generated shape
    % subplot(1, 3, i);
    hold on;
    label = "scale=" + num2str(s(i)) + ", rot=" + num2str(r(i)) + ", translat=(" + num2str(x(i)) + "," + num2str(y(i)) + ")";
    labels = [labels; label];
    scatter(generated_shape(:, 1), generated_shape(:, 2));
end
legend(labels);

%% 2. feature extraction

orig_image = cell2mat(handdata.images(1));
figure();
imshow(orig_image);
feature_matrix = computeFeatures(orig_image);

% Changes row vectors of features to matrix
gray_values = reshape(feature_matrix(1,:), [], size(orig_image, 1))';
gradient_x = reshape(feature_matrix(2,:),  [], size(orig_image, 1))';
gradient_y = reshape(feature_matrix(3,:),  [], size(orig_image, 1))';
gradient_strength = reshape(feature_matrix(4,:),  [], size(orig_image, 1))';
hl_image = reshape(feature_matrix(5,:),  [], size(orig_image, 1))';
hl_gradient_strength = reshape(feature_matrix(6,:),  [], size(orig_image, 1))';
coord_x = reshape(feature_matrix(7,:),  [], size(orig_image, 1))';
coord_y = reshape(feature_matrix(8,:),  [], size(orig_image, 1))';

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

%% 3. classification & feature selection
rng(1) % set seed so random values are always the same
    
% a) Compute random forest
% train with the first 30 images (rest is for testing)
train_images = handdata.images(1:30);
train_masks = handdata.masks(1:30);

random_forest = trainRF(train_images, train_masks);

% b) Inspect error
error = oobError(random_forest);
figure();
plot(error)
title('oobError');

% c) Plot error
figure();
plot(random_forest.OOBPermutedVarDeltaError)
title('Random Forrest Error');

%% 4. shape particle filters
% a.1) Train (get PCA shape model from 1. and random forest from 3.)
pca_shape_model = [meanShape, eigval, eigvec];

% a.2) Predict contour in test image
% Index of test image (31 - 50)
image_index = 45; 
test_image = handdata.images(image_index);

% Predict contour with random forest of training images
[features, labels, scores] = predictSegmentation(test_image, random_forest); 

% Format predicted contour
predict_contour = reshape(scores(:,1)', [], size(cell2mat(test_image),1))';
predict_contour = uint8(predict_contour.*255);

figure();
imagesc(predict_contour);
title("Predicted countour of image " + image_index);
axis equal;

% Clean up predicted contour
contour = predict_contour > 100;
predict_contour(contour) = 255;

figure();
imagesc(predict_contour);
title("Cleaned up countour of image " + image_index + " (with threshold < 100)");
axis equal;
