function random_forest = trainRF(images, masks)
features = [];
labels = [];

for i=1:size(images, 2)
    % compute the features for every image
    feature = computeFeatures(cell2mat(images(i)));

    % save current mask as row vector to get the label
    % countouring pixels are 10, background pixels are 0
    mask = cell2mat(masks(i)).';
    label = mask(:).';
    
    % get number of countouring pixels
    num_contour_pixels = sum(label==10);
    
    % get all background pixels
    background = find(label==0);
    
    % get as many random background pixels as there are contouring pixels
    random_background = background(randperm(numel(background), num_contour_pixels)); 
    
    % find all data points that are either part of the contour
    % or the random background pixels
    data_points = [random_background, find(label == 10)];
    
    % extract the labels and features at data_points for training
    training_feature = feature(:, data_points);
    training_label = label(data_points);
    
    % save features of all images in one matrix
    features = [features,training_feature];

    % save labels of all images in one matrix
    labels=[labels,training_label];
    
end

% compute random forest (32 trees) 
random_forest = TreeBagger(32,features',labels','OOBVarImp','on');
end