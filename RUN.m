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
    %D = [4 2 0.5; 4.2 2.1 0.59; 3.9 2.0 0.58; 4.3 2.1 0.62; 4.1 2.2 0.63];
    
    % Kovarianzmatrix ourCov
    C = ourCov(D);
    % Kovarianzmatrix Matlab cov
    C_m = cov(D);
    
    if C == C_m
        fprintf("covariance matrices are equal\n")
    end
    
    plot(C)
    %axis equal;
    
end

%% Principal Component Analysis
for i=1:numel(fn)
    D = data.(fn{i});
    %D = [4 2 0.5; 4.2 2.1 0.59; 3.9 2.0 0.58; 4.3 2.1 0.62; 4.1 2.2 0.63];
    
    %PCA
    [e_val, e_vec] = pca(D);
    
    %Plot
    plot2DPCA()
    
end

%% Unterraum-Projektion

%% Untersuchungen in 3D

%% Shape Modell


