close all;
clc;

addpath('beispiel_pca_material');
data_path = "beispiel_pca_material";

% Daten importieren
data = load(data_path + "/daten.mat");
fn = fieldnames(data);

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
    
    plot(D)
    %axis equal;
        
end

%% Principal Component Analysis
for i=1:numel(fn)
    D = data.(fn{i});
    
    %PCA
    [eigval, eigvec] = pca(D);
    
    %Plot 2D
    plot2DPCA(D', mean(D, 2), 0, eigvec, eigval, 1, 0)
    
end

%% Unterraum-Projektion

%% Untersuchungen in 3D

%% Shape Modell


