function [e_val, e_vec] = pca(D)
%PCA Summary of this function goes here
%   Detailed explanation goes here

% Anzahl der Datenpunkte
n = size(D,1);

% Einsvektor mit Länge n 
one_vector = ones(1, n);

% berechnet den Mittelwert jeder Spalte
% (one_vector * D) berechnet die Summe jeder Spalte
d_mean = (one_vector * D) / n;

% von jedem Wert in D wird der Mittelwert seiner Spalte abgezogen 
% c_mean(one_vector, :) dubliziert die 
D = D - d_mean(one_vector, :);

% Eigenvectoren und Eigenvalues berechnen
[eigenvectors, eigenvalues] = eig(ourCov(D));

% Eigenwerte absteigend sortieren
[e_val,ind] = sort(diag(eigenvalues),'descend');

% Eigenvektoren nach absteigenden Eigenwerten sortieren
e_vec = eigenvectors(ind, :);

end

