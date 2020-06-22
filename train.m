function [pca_shape_model, random_forest] = train(images, masks, shapes)
    % 1. PCA shape model
    % Calculate mean
    shapes_mean = mean(shapes, 2);
    
    % Compute PCA
    [eigen_values, eigen_vectors] = ourPca(shapes);
    pca_shape_model = [shapes_mean', eigen_values, eigen_vectors]; 
    
    % 2. Compute random forest
    random_forest = trainRF(images, masks);
end