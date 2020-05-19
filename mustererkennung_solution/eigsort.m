% first name last name, matriculation number
function [sortedVectors, sortedValues] = eigsort(eigenvectors, eigenvalues)
% INPUT
% eigenvectors
% eigenvalues

% OUTPUT
% sortedVectors ... sorted Eigenvectors (decending)
% sortedValues ... sorted Eigenvalues (decending)

sortedValues = diag(sort(diag(eigenvalues),'descend'));
[bla, ind] = sort(diag(eigenvalues),'descend'); 
sortedVectors = eigenvectors(:,ind); 

end

