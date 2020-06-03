function [feature_matrix] = computeFeature(image)
%COMPUTEFEATURE Calculates several features for the input image and returns
% a matrix with dimension n_features x n_pixels
%   Calculated features: gray value of a pixel, gradient (x and y
%   direction), gradient strength, Haar-like features on the gray scale
%   image, Haar-like features on the gradient strength, x- and
%   y-coordinates of the pixel

% Gray values
image_gv = double(image);

% Gradient calculation (x and y direction)
[gradient_x, gradient_y] = gradient(image_gv);

% Gradient magnitude and gradient direction
[gradient_strength, gradient_dir] = imgradient(image_gv);

% Haar-like features calculated on gray scale image and transformation to matrix
hl_image_vec = computeHaarLike(image_gv);
hl_image = vec2mat(hl_image_vec(1,:),size(image_gv,1))';

% Haar-like features calculated on gradient strength and transformation to matrix
hl_gradient_vec = computeHaarLike(gradient_strength);
hl_gradient = vec2mat(hl_gradient_vec(1,:),size(image_gv,1))';

hilfsmat=repmat((1:size(image_gv,1))',1,size(image_gv,2));%Hilfsmatrix für y-Koordinaten
%feature-matrix: Matrizen in Zeilenvektoren umgespeichert. (Spaltenvektoren
%sind alle Features zu einem Pixel)
for i=1:size(image_gv,1)
    feature_matrix(1,((i-1)*size(image_gv,2)+1):(i*size(image_gv,2)))=image_gv(i,:); %grau werte
    feature_matrix(2,((i-1)*size(image_gv,2)+1):(i*size(image_gv,2)))=gradient_x(i,:); %Gradient in x-Richtung
    feature_matrix(3,((i-1)*size(image_gv,2)+1):(i*size(image_gv,2)))=gradient_y(i,:); %Gradient in y-Richtung
    feature_matrix(4,((i-1)*size(image_gv,2)+1):(i*size(image_gv,2)))=gradient_strength(i,:); %Gradientenstärke
    feature_matrix(5,((i-1)*size(image_gv,2)+1):(i*size(image_gv,2)))=hl_image(i,:);%HL Feature des Grauwertbildes
    feature_matrix(6,((i-1)*size(image_gv,2)+1):(i*size(image_gv,2)))=hl_gradient(i,:);%HL Feature der Gradientenstärke    
    feature_matrix(8,((i-1)*size(image_gv,2)+1):(i*size(image_gv,2)))=hilfsmat(i,:); %y-Koordinate des Pixels
end

feature_matrix(7,:)=repmat(1:size(image_gv,2),1,size(image_gv,1)); %x-Koordinate des Pixels

end

