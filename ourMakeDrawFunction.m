function f = ourMakeDrawFunction(probability_map, eigen_vectors, mean_shape)
    f = @drawFunction;
    function h = drawFunction(pop, bestInd)

        p = pop(:, bestInd);
        
        b = p(5:end);
        generated_shape = generateShape(b, eigen_vectors, mean_shape, p(1), p(2), p(3), p(4));
        
        h(1) = imshow(probability_map); hold on;
        h(2) = scatter(generated_shape(:,1), generated_shape(:,2));
    end
end