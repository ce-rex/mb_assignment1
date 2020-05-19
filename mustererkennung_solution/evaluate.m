% first name last name, matriculation number

function [error] = evaluate(classification, gt)
% INPUT
% classification -> result of classifier
% gt -> ground truth, real class labels

% OUTPUT
% error -> how many samples were classified incorrect in %

error = sum(classification ~= gt) / length(classification) * 100;
end

