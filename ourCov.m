function C = ourCov(D)
% Berechnet die Kovarianzmatrix für D

one_vector = ones(1, size(D,1));

% berechnet den Mittelwert jeder Spalte
c_mean = (one_vector * D) / size(D,1);

% subtrahiert den Mittelwert von den Werten in dieser Spalte
D_substract_mean = D - c_mean(one_vector, :);


C = (D_substract_mean.' * D_substract_mean) / (size(D,1) - 1);

end

