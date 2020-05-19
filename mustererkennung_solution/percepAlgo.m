% first name last name, matriculation number

function [w] = percepAlgo(X, y, maxEpochs)
% INPUT
% X ... training data (in homogeneous coordinates)
% t ... ground truth, class labels (+1/-1)
% maxEpochs ... maximum number of epochs during training

% OUTPUT
% w ... vector containing weights and bias

% TODO 1.2
% number of samples
N = size(X,2);
% number of variables
M = size(X,1);

% learning rate
l = 1;

% initialize w
w = zeros(M,1);
% is true if there was an update of w
update = true;
% counter for epochs
epoch = 0;

while epoch < maxEpochs && update
    update = false;
    epoch = epoch + 1;
    for i = 1 : N
        if dot(w,X(:,i)*y(i)) <= 0
            w = w + l*X(:,i)*y(i);
            update = true;
        end
    end
end
disp(['Number of epochs: ', sprintf('%d',epoch)]);
end


