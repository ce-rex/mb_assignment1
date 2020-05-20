function [eigval, eigvec] = pca(D)
%PCA Summary of this function goes here
%   Detailed explanation goes here

% Eigenvektoren und Eigenvalues berechnen
[eigvec, eigval] = eig(ourCov(D'));

% Eigenwerte absteigend sortieren
[eigval,ind] = sort(diag(eigval),'descend'); 

% Eigenvektoren nach absteigenden Eigenwerten sortieren
eigvec = transpose(eigvec(ind, :));

end

