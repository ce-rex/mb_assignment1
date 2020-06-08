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

cost = computeCost(sample31_mask, [0, 1, 0, 0], eigvec, meanShape)

% (c)

minimums = [-30;0.75;-200;-200];
maximums = [30;1.25;200;200];

%fuer alle Testbiler berechnen (31-50):
for i=31:50
    clear testimage label score imagefeat predcont predscorecont testlandmarks
    tic
    testimage = cell2mat(handdata.images(i)); %Testimage auswaehlen
    [label,score,imagefeat]=predictsegmentation(rf,testimage); 
    predscorecont= vec2mat(score(:,2),imagefeat(7,size(label,1))); %Wahrscheinlichkeit, dass ein Pixel im Hintergrund liegt.
    
    costFunction = makeCostFunction(pcashape,predscorecont,@costfunct);
    drawPop = makedrawPopulation(pcashape,@drawPopulation);
    
    %ohne Ausgabe:
    optparameters=optimize(costFunction,minima,maxima);
    
    %mit Ausgabe:
    %imshow(testimage)
    %hold on
    %optparameters=optimize(costFunction,minimums,maximums,drawPop);
    %hold off
    
    bnew=ones(sum((pcashape(:,2)/sum(pcashape(:,2)))>0.001),1); %nur jene Modes verwenden die mindest 0.1% der Gesamtvarianz beitragen.
    currentshape=generateShape(bnew,pcashape(:,3:end),pcashape(:,1)',optparameters(1),optparameters(2),optparameters(3),optparameters(4));
    
    %Speichern der Optima:
    optimum((i-30),1:4)=optparameters(1:4); %Optimumparameter
    optshapes((((i-30)*2)-1):((i-30)*2),:)=currentshape; %Optimumshapes
    opttime((i-30))=toc; %Berechnungszeit des Optimums
end

% %Darstellung der predicted und wahren Shape von image k (in unserem
% Report fuer k=31,37)
k=31;
bnew=ones(sum((pcashape(:,2)/sum(pcashape(:,2)))>0.001),1); %nur jene Modes verwenden die mindest 0.1% der Gesamtvarianz beitragen.
pcalandmarks=generateShape(bnew,pcashape(:,3:end),pcashape(:,1)',0,1,0,0);
truelandmarks= cell2mat(handdata.landmarks(k));
predlandmarks= optshapes(((k-31)*2+1):(k-30)*2,:);
imshow(uint8(cell2mat(handdata.images(k))))
hold on
plot([truelandmarks(1,:),truelandmarks(1,1)],[truelandmarks(2,:),truelandmarks(2,1)])
plot([predlandmarks(1,:),predlandmarks(1,1)],[predlandmarks(2,:),predlandmarks(2,1)])
plot([pcalandmarks(1,:),pcalandmarks(1,1)],[pcalandmarks(2,:),pcalandmarks(2,1)])
legend('TrueShape','PredictedShape','PcaShape')
hold off

% (d)

