close all;
clc;

addpath('beispiel_pca_material');
data_path = "beispiel_pca_material";

% Daten importieren
data = load(data_path + "/daten.mat");
data3d = load(data_path + "/daten3d.mat");
fn = fieldnames(data);
fn3d = fieldnames(data3d);

%% Kovarianzmatrix
for i=1:numel(fn)
    D = data.(fn{i});
    
    % Kovarianzmatrix ourCov
    C = ourCov(D);
    % Kovarianzmatrix Matlab cov
    C_m = cov(D);
    
    %if C == C_m
    %    fprintf("covariance matrices are equal\n")
    %end 
    
    %figure(i)
    %scatter(D(1,:), D(2,:))
    %axis equal;
        
end


%% Principal Component Analysis
for i=1:numel(fn)
    D = data.(fn{i});
    
    %PCA
    [eigval, eigvec] = ourPca(D);
    
    %Plot 2D
    %plot2DPCA(D', mean(D, 2), 0, eigvec, eigval, 1, 0)
    
end

%% Unterraum-Projektion
D = data.data3;
    
%PCA
[eigval, eigvec] = ourPca(D);

figure(1)
scatter(D(1,:), D(2,:))
title('Original data3 in 2D space');

%%% Main vector

%Projection
data_projected = projection(eigvec(:,1), D);
    
figure(2)
scatter(data_projected(1,:), zeros(1, 50))
title('Projection of data3 to 1D space (main vector)');

%Reconstruction
mean_orig = mean(D, 2);
data_reconstructed = reconstruction(eigvec(:,1), data_projected, mean_orig); 

figure(3)
scatter(data_reconstructed(1,:), data_reconstructed(2,:))
title('Reconstruction data3 (main vector)');

plot2DPCA(D', mean_orig, data_reconstructed', eigvec, eigval, 1, 1);

reconstruction_error = immse(D, data_reconstructed)


%%% Side vector
data_projected_side = projection(eigvec(:,2), D);
    
figure(5)
scatter(data_projected_side(1,:), zeros(1, 50))
title('Projection of data3 to 1D space (side vector)');

%Reconstruction
mean_orig_side = mean(D, 2);
data_reconstructed_side = reconstruction(eigvec(:,2), data_projected_side, mean_orig_side); 

figure(6)
scatter(data_reconstructed(1,:), data_reconstructed(2,:))
title('Reconstruction data3 (side vector)');

plot2DPCA(D', mean_orig_side, data_reconstructed_side', eigvec, eigval, 1, 1);

reconstruction_error_side = immse(D, data_reconstructed_side)


%% Untersuchungen in 3D

data = load(data_path + "/daten3d.mat");
D = data.data;

%PCA
[eigval, eigvec] = ourPca(D);
mju = mean(D, 2);

% plot data, eigenvectors and ellipsoids of standard deviation
plot3DPCA(D', mju', eigvec, eigval, 1, 0);

% project to 2D space
data_projected = projection(eigvec(:,1:2), D);

% plot projection
figure(5)
scatter(data_projected(1,:), data_projected(2,:));
title('Projected data3d in 2D space');

% plot original and reconstructed data points
plot3DPCA(D', mju', eigvec, eigval, 0, 1);



%% Shape Modell

data = load(data_path + "/shapes.mat");
shapes = data.aligned;

for i=1:size(shapes, 3)
    
    D = shapes(:,:,i)';
    
    %PCA
    [eigval, eigvec] = ourPca(D);
    
    %Plot 2D
    plot2DPCA(D', mean(D, 2), 0, eigvec, eigval, 1, 0)

end