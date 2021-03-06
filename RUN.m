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
coord_x = reshape(feature_matrix(5,:),  [], size(orig_image, 1))';
coord_y = reshape(feature_matrix(6,:),  [], size(orig_image, 1))';
hl_image = feature_matrix(7:26,:);
hl_gradient_strength = feature_matrix(27:end,:);

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
imagesc(reshape(hl_image(1,:)', [], size(orig_image, 2)));
axis equal
title('Haar-like Features of Gray-Scale Image');

figure();
imagesc(reshape(hl_gradient_strength(1,:)', [], size(orig_image, 2)));
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

% b) Plot oobError
figure();
plot(oobError(random_forest));
xlabel('Number of trees', 'FontSize', 12)
ylabel('Out-of-bag classification error', 'FontSize', 12)
ax = gca;
ax.FontSize = 14;

% c) Plot importance of features
figure();
e = random_forest.OOBPermutedVarDeltaError;
bar(random_forest.OOBPermutedVarDeltaError)
ylabel('Importance of feature for prediction', 'FontSize', 12)
ax = gca;
ax.FontSize = 14;
xticks([1 2 3 4 5 6 7 27])
xticklabels({'grey value','x-gradident','y-gradient','gradient magnitude','x-coordinate','y-coordinate','haar-like grey value (7-26)','haar-like gradient magnitude (27-46)'});
xtickangle(40);

%% 4. shape particle filters
% (a)
% a.1) Train
[pca_shape_model, random_forest] = train(train_images, train_masks, shapes_flattened);
meanShape = cell2mat(pca_shape_model(1));
eigval = cell2mat(pca_shape_model(2));
eigvec = cell2mat(pca_shape_model(3));

% a.2) Predict contour in test image
% Index of test image (31 - 50)
image_index = 45;
test_image = handdata.images(image_index);

% Predict contour with random forest of training images
[features, labels, scores] = predictSegmentation(test_image, random_forest);

% Reformat predicted contour
predicted_contour = reshape(scores(:,1)', [], size(cell2mat(test_image),1))';

% Plot predicted contour
figure();
imagesc(predicted_contour);
title("Predicted countour of image " + image_index, 'FontSize', 12);
axis equal;

% Plot original image
figure();
imagesc(cell2mat(test_image));
title("Original image " + image_index);
axis equal;

%% (b) create cost function

% Predict contour with random forest of training images
test_image = handdata.images(31);
[features, labels, scores] = predictSegmentation(test_image, random_forest);

% Format predicted contour
predict_contour = reshape(scores(:,1)', [], size(cell2mat(test_image),1))';
probability_map_bg = predict_contour; % pixel-wise "probability" that pixel is background

% use a reasonable setting for a shape to use as an (imperfect) overlay
b = [0, 0, 0, 0, 0];
p = [0, 1, 60, 150, b];

% compute cost
cost = computeCost(probability_map_bg, p, eigvec, meanShape);

% print cost
disp(['Cost: ', num2str(cost)])

% visualize result
drawFunction = ourMakeDrawFunction(probability_map_bg, eigvec, meanShape);
figHandles = feval(drawFunction,p',1);
drawnow

%% (c) optimize

% set suitable boundaries for b (-5 to 5 times standard deviation)
b_min = -5 * sqrt(eigval(1:5));
b_max = 5 * sqrt(eigval(1:5));

optimum_parameters = zeros(20, 9);

% optimize p for all test images
for i=31:50

    disp(i)
    test_image = handdata.images(i);

    % Predict contour with random forest of training images
    [features, labels, scores] = predictSegmentation(test_image, random_forest);

    % Format predicted contour
    predict_contour = reshape(scores(:,1)', [], size(cell2mat(test_image),1))';
    probability_map_bg = predict_contour;

    % set boundaries for all parameters
    minima = [-45; 0.5; 0; 0; b_min];
    maxima = [45; 2; size(probability_map_bg, 2); size(probability_map_bg, 1); b_max];

    % close current figures
    % close all

    %testimage = cell2mat(handdata.images(i)); %Testimage auswaehlen
    %[label,score,imagefeat]=predictsegmentation(rf,testimage);
    %predscorecont= vec2mat(score(:,2),imagefeat(7,size(label,1))); %Wahrscheinlichkeit, dass ein Pixel im Hintergrund liegt.

    costFunction = ourMakeCostFunction(probability_map_bg, eigvec, meanShape);
    % drawFunction = ourMakeDrawFunction(probability_map_bg, eigvec, meanShape);

    % optimize and save best result
    % NOTE: uncomment to perform optimization
    % optimum_parameters((i-30),:) = optimize(costFunction, minima, maxima, drawFunction);

end

%% (d) Evaluate segmentation performance
% Generate a shape for each test sample given the computed optimum
% parameters. Compare it to the ground truth. Visualize the differences for
% the test set with a boxplot

optimum_parameters = load("optimum_parameters_46features");
optimum_parameters = optimum_parameters.optimum_parameters;

gt_shapes = handdata.landmarks;
dice_coefficients = zeros(20, 1);

for i=31:50
    
   test_image = handdata.images(i);

   % Predict contour with random forest of training images
   [features, labels, scores] = predictSegmentation(test_image, random_forest);

   % Format predicted contour
   predict_contour = reshape(scores(:,1)', [], size(cell2mat(test_image),1))';
   probability_map_bg = predict_contour; 
    
   % generate shape given the optimum parameters
   p = optimum_parameters((i-30),:);
   b = p(5:end)';
   generated_shape = generateShape(b, eigvec, meanShape, p(1), p(2), p(3), p(4)); 
   
   gt_shape = cell2mat(handdata.landmarks(i));
   
   generated_poly = polyshape(generated_shape(:,1), generated_shape(:,2));
   gt_poly = polyshape(gt_shape(1,:), gt_shape(2,:));

   % optional: visualize result for each sample
%    figure()
%    imshow(probability_map_bg)
%    hold on;
%    plot(gt_poly)
%    hold on;
%    plot(generated_poly);
%    title(['image #', num2str(i)])
%    lgd = legend(["ground truth", "prediction"],  'Location', 'eastoutside');

   % compute intersection overlay
   intersection = intersect(generated_poly, gt_poly);

   % compute overlay metric (dice coefficient)
   dice_coefficients(i-30) = 2 * area(intersection) / (area(generated_poly) + area(gt_poly));
   
end

% load results for different settings
dice_8features = load("dice_coefficients-8features");
dice_8features = dice_8features.dice_coefficients;
dice_1000iters = load("dice_coefficients-1000iters");
dice_1000iters = dice_1000iters.dice_coefficients;

figure()
boxplot([dice_coefficients, dice_8features, dice_1000iters], {'46 features, 10k convergence', '8 features, 10k convergence', '46 features, 1k convergence'})
title("Segmentation performance on test set (Dice score)");
xtickangle(40);
