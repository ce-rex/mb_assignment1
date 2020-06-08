function total_costs = computeCost(probability_map, p, eigen_vectors, mean_shape)
% COMPUTECOST Returns a scalar value representing the costs which describe 
% how well the (from p) generated shapes fit the classification result.
%   probability_map: classification result
%   p: parameter vector, p = (scaling, rotation, x?translation,
%   y?translation, b)
%   eigen_vectors: Eigen vectors to limit the number of modes
%   total_costs: returned costs as a sum of the costs of the single points

b = p(5:length(p));
generated_shape = generateShape(b, eigen_vectors, mean_shape, p(1), p(2), p(3), p(4));

total_costs=0;
for i=1:size(generated_shape,2) %Schleifenberechnung ueber alle Punkte
    [c1,c2,probability] = improfile(probability_map,generated_shape(1,i),generated_shape(2,i)); %contprob.. Wahrscheinlichkeit, dass der Punkt im Hintergrund liegt( also im Intervall [0,1])
    % If contprob is not a number, the shape is bigger than the
    % probability map. In this case, contprob is set to 1 since the
    % probability that this point is part of the background is 100%.
    % Idea for better approach: distance measure (denn wenn der Punkt auch
    % nur 1 Pixel daneben ist, ist die Wahrscheinlichkeit der
    % Übereinstimmung gleich 0)
    if isnan(probability)
        probability = 1; 
    % The higher the probability that the point is part of the background,
    % the higher the costs (*1000 for easier numbers)
    cost = probability * 1000; 
    end
    total_costs = total_costs + cost; 
end

end