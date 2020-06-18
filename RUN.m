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

shapes = handdata.aligned;

% flatten shapes to make them digestable for ourPca. yum
shapes_flattened = reshape(shapes, 128, 50);
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

%% feature extraction

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

%% classification & feature selection
rng(1) % set seed so random values are always the same
    
% a) Compute random forest
% train with the first 30 images (rest is for testing)
training_images = handdata.images(1:30);
training_masks = handdata.masks(1:30);

random_forest = trainRF(training_images, training_masks);

% b) Inspect error
error = oobError(random_forest);

% c) Plot error
figure();
plot(random_forest.OOBPermutedVarDeltaError)
title('Random Forrest Error');

%% shape particle filters

%% (a)

%% (b) create cost function

% load gaussian filtered GT segmentation mask as probabililty map
probability_map_bg = abs(imgaussfilt(cell2mat(handdata.masks(31)), 5) / 10 - 1);

% use a reasonable setting
b = [0, 0, 0, 0, 0];
p = [0, 1, 60, 150, b];

% compute cost
cost = computeCost(probability_map_bg, p, eigvec, meanShape);

% print cost
disp(cost)

% visualize result
drawFunction = ourMakeDrawFunction(probability_map_bg, eigvec, meanShape);
figHandles = feval(drawFunction,p',1);
drawnow

%% (c) optimize

% set boundaries for b
b_min = -5 * sqrt(eigval(1:5));
b_max = 5 * sqrt(eigval(1:5));

% optimize p for all test images
for i=31:50
    
    % load gaussian filtered GT segmentation mask as probabililty map
    probability_map_bg = abs(imgaussfilt(cell2mat(handdata.masks(i)), 5) / 10 - 1);
    
    % set boundaries for all parameters
    minima = [-45; 0.5; 0; 0; b_min];
    maxima = [45; 2; size(probability_map_bg, 2); size(probability_map_bg, 1); b_max];
    
    % close current figures
    close all
    
    %testimage = cell2mat(handdata.images(i)); %Testimage auswaehlen
    %[label,score,imagefeat]=predictsegmentation(rf,testimage); 
    %predscorecont= vec2mat(score(:,2),imagefeat(7,size(label,1))); %Wahrscheinlichkeit, dass ein Pixel im Hintergrund liegt.
    
    costFunction = ourMakeCostFunction(probability_map_bg, eigvec, meanShape);
    drawFunction = ourMakeDrawFunction(probability_map_bg, eigvec, meanShape);
    
    % optimize and save best result
    optparameters = optimize(costFunction, minima, maxima, drawFunction);
        
    %Speichern der Optima:
    optimum((i-30),:) = optparameters; % Optimumparameter
    %optshapes((((i-30)*2)-1):((i-30)*2),:)=currentshape; %Optimumshapes
end

%% (d)

