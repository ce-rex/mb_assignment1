% first name last name, matriculation number
function [trainingMeanSubtracted] = determineMeanSubtracted(training, meanVector)
% INPUT
% training ... training set
% meanVector ... mean vector of training set

% OUTPUT
% trainingMeanSubtracted ... training data minus mean vector (mean object)

noC = size(training,2);
trainingMeanSubtracted = zeros(size(training));

for i = 1 : noC
    trainingMeanSubtracted(:,i) = training(:,i)-meanVector;
end
end

