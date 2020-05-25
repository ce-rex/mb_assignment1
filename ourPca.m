function [eigval, eigvec] = ourPca(D)
%ourPca computes a PCA over D

% Calculates Eigenvalues and Eigenvectors
[eigvec, eigval] = eig(ourCov(D'));

% Sort Eigenvalues descending
[eigval,ind] = sort(diag(eigval),'descend'); 
eigvec = eigvec(:, ind);

end

