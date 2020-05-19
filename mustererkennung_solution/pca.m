% first name last name, matriculation number

% Load dataset -> Task 2.1
[test, training] = loadData();

% Mean vector -> Task 2.2
meanVector = determineMeanVector(training);

% Subtract mean vector from training data -> Task 2.3
A = determineMeanSubtracted(training, meanVector);

% Eigenvectors and Eigenvalues of A'A -> Task 2.4
[eigenvectors, eigenvalues] = eig(A'*A);  
[eigenvectors, eigenvalues] = eigsort(eigenvectors, eigenvalues);

% Basis (Eigenobjects) -> Task 2.5
U = determineBasis(A, eigenvectors);

% Reconstruction and evaluation -> TODO 2.7
errorTrain = reconstructEval(U, training, meanVector);
errorTest = reconstructEval(U, test, meanVector);

figure;
hold on;
title('Reconstruction error per sample');
xlabel('number of eigenvectors'); % x-axis label
ylabel('error per sample'); % y-axis label
axis([1, size(U,2), 0, max([errorTrain errorTest])]); % limits of axis
plot(errorTrain,'g');
plot(errorTest, 'r');
hold off;