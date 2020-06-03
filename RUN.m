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

image1 = cell2mat(handdata.images(1));
figure();
imshow(image1);
imagesccache = computeFeatures(image1);

%Features Zeilenvektoren in Matrix umschreiben und darstellen.
grayValues = vec2mat(imagesccache(1,:), 143);
xGradient = vec2mat(imagesccache(2,:), 143);
yGradient = vec2mat(imagesccache(3,:), 143);
gradientStrength = vec2mat(imagesccache(4,:), 143);
haarLike = vec2mat(imagesccache(5,:), 143);
haarLikeGradStrength = vec2mat(imagesccache(6,:), 143);
xCoord = vec2mat(imagesccache(7,:), 143);
yCoord = vec2mat(imagesccache(8,:), 143);

figure;
imagesc(grayValues);
axis equal
title('gray Values');

figure;
imagesc(xGradient);
axis equal
title('x Gradient');

figure;
imagesc(yGradient);
axis equal
title('y Gradient');

figure;
imagesc(gradientStrength);
axis equal
title('gradient Strength');

figure;
imagesc(haarLike);
axis equal
title('haar Like Features');

figure;
imagesc(haarLikeGradStrength);
axis equal
title('Haar features gradienr strength');

figure;
imagesc(xCoord);
axis equal
title('x-Coordinates');

figure;
imagesc(yCoord);
axis equal
title('y-Coordinates');

%% classification & feature selection

% code

%% shape particle filters

% code

