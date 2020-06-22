function f = ourMakeCostFunction(probability_map, eigen_vectors, mean_shape)
    f = @costFunction;
    function c = costFunction(params)
        c = computeCost(probability_map, params', eigen_vectors, mean_shape);
    end
end