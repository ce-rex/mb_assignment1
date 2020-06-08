function f = makeCostFunction(costSurface)
    f = @costFunction;
    function c = costFunction(params)
        c = costSurface(round(params(2)),round(params(1)));
    end
end