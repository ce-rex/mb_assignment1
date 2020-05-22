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
    
    figure(i)
    scatter(D(1,:), D(2,:))
    axis equal;
        
end


%% Principal Component Analysis
for i=1:numel(fn)
    D = data.(fn{i});
    
    %PCA
    [eigval, eigvec] = ourPca(D);
    
    %Plot 2D
    plot2DPCA(D', mean(D, 2), 0, eigvec, eigval, 1, 0)
    
end

%% Unterraum-Projektion

%% Untersuchungen in 3D

data = load(data_path + "/daten3d.mat");
D = data.data;

%PCA
[eigval, eigvec] = ourPca(D);
mju = mean(D, 2);

plot3DPCA(D', mju', eigvec, eigval, 0, 1)



%% Shape Modell

data = load(data_path + "/shapes.mat");
shapes = data.aligned;

for i=1:size(shapes, 3)
    
    D = shapes(:,:,i)';
    
    %PCA
    [eigval, eigvec] = pca(D);
    
    %Plot 2D
    plot2DPCA(D', mean(D, 2), 0, eigvec, eigval, 1, 0)

end