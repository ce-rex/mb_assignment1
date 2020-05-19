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
    
    if C == C_m
        fprintf("covariance matrices are equal\n")
    end
    
    plot(C)
    %axis equal;
    
end

%% PCA

%% Unterraum-Projektion

%% Untersuchungen in 3D

%% Shape Modell


