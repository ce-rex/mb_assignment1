function [r, mi, ma] = makeOptimizationLandscape1
    mi = [1; 1];
    ma = [ 300;  200];
    [X,Y] = meshgrid((mi(1):ma(1))-100,(mi(2):ma(2))-70);
    r = sqrt(X.^2 + Y.^2)/5;
    r = -sin(r)./r;
    r(isnan(r)) = -1;
end