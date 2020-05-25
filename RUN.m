close all;
clc;

% Defines and adds data path
data_path = "beispiel_pca_material";
addpath(data_path);

% Imports data
data = load(data_path + "/daten.mat");
data3d = load(data_path + "/daten3d.mat");
fn = fieldnames(data);
fn3d = fieldnames(data3d);

%% Covariance Matrix
for i=1:numel(fn)
    D = data.(fn{i});
    
    % Covariance matrix ourCov
    C = ourCov(D);
    % Covariance matrix Matlab cov
    C_m = cov(D);
    
    % Checks if results are equal
    % if C == C_m
    %    fprintf("covariance matrices are equal\n")
    % end 
    
    % Data plots
    figure()
    scatter(D(1,:), D(2,:))
    title(strcat('Plot of data', num2str(i)));
    axis equal;
        
end


%% Principal Component Analysis

% identify modes
for i=1:numel(fn)
    D = data.(fn{i});
    
    %PCA
    [eigval, eigvec] = ourPca(D);
    
    %Plot 2D
    plot2DPCA(D', mean(D, 2), 0, eigvec, eigval, 1, 0)
    
end

%% Subspace Projection
D = data.data3;
    
%PCA
[eigval, eigvec] = ourPca(D);

figure()
scatter(D(1,:), D(2,:))
title('Original data3 in 2D space');

%%% Main vector

%Projection
data_projected = projection(eigvec(:,1), D);
    
figure()
scatter(data_projected(1,:), zeros(1, 50))
title('Projection of data3 to 1D space (main vector)');

%Reconstruction
mean_orig = mean(D, 2);
data_reconstructed = reconstruction(eigvec(:,1), data_projected, mean_orig); 

figure()
scatter(data_reconstructed(1,:), data_reconstructed(2,:))
title('Reconstruction data3 (main vector)');

plot2DPCA(D', mean_orig, data_reconstructed', eigvec, eigval, 1, 1);

reconstruction_error = immse(D, data_reconstructed);


%%% Side vector

%Projection
data_projected_side = projection(eigvec(:,2), D);
    
figure()
scatter(data_projected_side(1,:), zeros(1, 50));
title('Projection of data3 to 1D space (side vector)');

%Reconstruction
mean_orig_side = mean(D, 2);
data_reconstructed_side = reconstruction(eigvec(:,2), data_projected_side, mean_orig_side); 

figure()
scatter(data_reconstructed(1,:), data_reconstructed(2,:))
title('Reconstruction data3 (side vector)');

plot2DPCA(D', mean_orig_side, data_reconstructed_side', eigvec, eigval, 1, 1);

reconstruction_error_side = immse(D, data_reconstructed_side);


%% Examinations in 3D

% Load data
data = load(data_path + "/daten3d.mat");
D = data.data;

% PCA
[eigval, eigvec] = ourPca(D);
mju = mean(D, 2);

% Plot data, eigenvectors and ellipsoids of standard deviation
plot3DPCA(D', mju', eigvec, eigval, 1, 0);

% Project to 2D space
data_projected = projection(eigvec(:,1:2), D);

% Plot projection
figure()
scatter(data_projected(1,:), data_projected(2,:));
title('Projected data3d in 2D space');

% Plot original and reconstructed data points
plot3DPCA(D', mju', eigvec, eigval, 0, 1);



%% Shape Modell

% Load data
addpath('beispiel_pca_material');
data_path = "beispiel_pca_material";
data = load(data_path + "/shapes.mat");
shapes = data.aligned;

% Flatten shapes so that ourPca can process them
shapes_flattened = reshape(shapes, 256, 14);

% Perform pca on the flattened shapes
[eigval, eigvec] = ourPca(shapes_flattened);

% Generate shape from the standard deviations of modes 1 to 5
generated_shape = generateShape(sqrt(eigval(1:5)));

% Plot generated shape
figure()
scatter(generated_shape(:, 1), generated_shape(:, 2));
title("Shape generated based on 5 modes")


mean_shapes = mean(shapes, 3);

std_shapes = sqrt(eigval);


% Exemplary loop for 14 modes, can be adapted - due to 14 training samples,
% the standard deviation of the 14th and later modes is 0
for i=1:14
   plotShape(reshape(eigvec(:,i), 128, 2), mean_shapes, std_shapes(i), i) 
end

%%% Create random b generator based on standard deviations
% list of number of eigenvectors to use
% 0.75 instead of 0.8 is used since a variance between 0.8 and 0.9 is not
% covered in our case
variance_fractions = [1, 0.95, 0.9, 0.75];

for target_fraction=variance_fractions
    for nEigenvectors=1:length(eigval)
        
        variance_fraction = sum(eigval(1:nEigenvectors))/sum(eigval);
        if variance_fraction >= target_fraction
            % Generate b using the given number of eigenvectors
            b = randn(1,nEigenvectors)' .* std_shapes(1:nEigenvectors);
            generated_shape = generateShape(b);
            
            % Plot generated shape
            figure()
            scatter(generated_shape(:, 1), generated_shape(:, 2))
            title({['Generated shape based on ', num2str(nEigenvectors), ' modes.'], ['Covers ', num2str(variance_fraction * 100), '% of total variance.']});
            xlim([-100, 100]);
            ylim([-170, 180]);
            break
        end
    end
end

