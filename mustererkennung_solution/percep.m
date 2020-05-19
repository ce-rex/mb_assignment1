% first name last name, matriculation number

% maximum number of allowed epochs for perceptron algorithm
maxEpochs = 100;

% read dataset
file = fopen('lilien.txt');
dataIris = textscan(file, '%f %f %f %f %f');
fclose(file);

% normalize the data
dataIris = {(dataIris{1}-min(dataIris{1}))./(max(dataIris{1})-min(dataIris{1})),(dataIris{2}-min(dataIris{2}))./(max(dataIris{2})-min(dataIris{2})),(dataIris{3}-min(dataIris{3}))./(max(dataIris{3})-min(dataIris{3})),(dataIris{4}-min(dataIris{4}))./(max(dataIris{4})-min(dataIris{4})), dataIris{5}};

% bring data in useable format
%X = [dataIris{1} dataIris{2} dataIris{3} dataIris{4}];
X = [dataIris{1} dataIris{3} dataIris{4}];

X = X';
X(size(X,1)+1,:) = 1;
y = dataIris{5}; y(y==0)=-1;

% training set
XTrain = [X(:,1:25) X(:,51:75)];
yTrain = [y(1:25); y(51:75)];

% test set
XTest = [X(:,26:50) X(:,76:100)];
yTest = [y(26:50); y(76:100)];

% Task 3.1
% apply Perceptron Algorithm
w = percepAlgo(XTrain, yTrain, maxEpochs);

% Task 3.2
% classify training set
result = zeros(size(XTrain,2),1);
for i = 1 : size(XTrain,2)
    result(i) = dot(w,XTrain(:,i));
end
result(result < 0) = -1;
result(result >= 0) = 1;
errorPercepTrain = evaluate(result,yTrain);
disp(['Error on training set: ', sprintf('%.2f',errorPercepTrain), '%']);

% classify test set
result = zeros(size(XTest,2),1);
for i = 1 : size(XTest,2)
    result(i) = dot(w,XTest(:,i));
end
result(result < 0) = -1;
result(result >= 0) = 1;
errorPercepTest = evaluate(result,yTest);
disp(['Error on test set: ', sprintf('%.2f',errorPercepTest), '%']);