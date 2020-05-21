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
    [eigval, eigvec] = pca(D);
    
    %Plot 2D
    %plot2DPCA(D', mean(D, 2), 0, eigvec, eigval, 1, 0)
    
end

%% Unterraum-Projektion
D = data.data3;
    
%PCA
[eigval, eigvec] = pca(D);

%Projection
data_projected = projection(eigvec(:,1), D);
    
figure(2)
scatter(data_projected(1,:), zeros(1, 50))
title('Projection of data3 to 1D space (main vector)');

figure(3)
scatter(D(1,:), D(2,:))
title('Original data3 in 2D space');

%Reconstruction
mean_orig = mean(D, 2);
data_reconstructed = reconstruction(eigvec(:,1), data_projected, mean_orig); 

%figure(4)
%scatter(data_reconstructed(1,:), data_reconstructed(2,:))
%title('Reconstruction data3 (main vector)');

plot2DPCA(D', mean_orig, data_reconstructed', eigvec, eigval, 1, 1);



%% Untersuchungen in 3D

%% Shape Modell


