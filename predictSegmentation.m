function [features, labels, scores] = predictSegmentation(image, random_forest)
    % compute image features
    features = computeFeatures(cell2mat(image));
    
    % predict (using predict fuction of TreeBagger class)
    [labels, scores] = predict(random_forest, double(features)');
    
    % convert labels from cell to matrix
    labels = cellfun(@str2num, labels);

end

