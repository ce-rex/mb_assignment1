% first name last name, matriculation number
function [meanVector] = determineMeanVector(training)
% INPUT
% training ... training set

% OUTPUT
% meanVector ... mean vector

meanVector = mean(training, 2);
end

