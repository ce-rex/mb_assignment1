function random_forest = trainRF(images, masks)
features = [];
labels = [];

for i=1:size(images, 2)
    % compute the features for every image
    feature = computeFeatures(cell2mat(images(i)));
    
    % save features of all images in one matrix
    features = [features,feature];

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
    
    % change value of random background pixels in label so they can be found again
    label(random_background) = 1;

    % save labels of all images in one matrix
    labels=[labels,label];
    
end

% get all pixels that are relevant for training (1, 10)
training_pixels = find(labels ~= 0);

% get the labels of the relevant pixels
training_labels = labels(training_pixels);

% get the features of the relevant pixels
training_features = features(:, training_pixels);

% compute random forest (32 trees) 
random_forest = TreeBagger(32,training_features',training_labels','OOBVarImp','on');
end