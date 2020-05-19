% first name last name, matriculation number
function [test, training] = loadData()
% OUTPUT
% test     ... test set (colum: sample, row: feature)
% training ... training set (colum: sample, row: feature)

% Define the location of the data set
path = 'coil-100/';

%% Training set
% Select four views of five classes (out of 100 classes)
selectedClasses = [1 2 3 4 5];
selectedViews = [0 : 45 : 315];

noC = length(selectedClasses);
noV = length(selectedViews);

training = zeros(128*128,noC*noV);

% Generate training set
for c = 1 : noC
    for v = 1 :  noV
        tempPath = ['obj', sprintf('%d',selectedClasses(c)),'__',sprintf('%d',selectedViews(v)),'.png'];
        imgBuffer = rgb2gray(imread([path,tempPath]));
        training(:,(c-1)*noV+v) = imgBuffer(:);
    end
end

%% Test set
% Select four views of five classes (out of 100 classes)
selectedClasses = [1 2 3 4 5];
selectedViews = [5 50 120 200];

noC = length(selectedClasses);
noV = length(selectedViews);

test = zeros(128*128,noC*noV);

% Generate test set
for c = 1 : noC
    for v = 1 :  noV
        tempPath = ['obj', sprintf('%d',selectedClasses(c)),'__',sprintf('%d',selectedViews(v)),'.png'];
        imgBuffer = rgb2gray(imread([path,tempPath]));
        test(:,(c-1)*noV+v) = imgBuffer(:);
    end
end
end

