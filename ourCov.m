function C = ourCov(D)
% Berechnet die Kovarianzmatrix für D

% Anzahl der Datenpunkte
n = size(D,1);

% Einsvektor mit Länge n 
one_vector = ones(1, n);

% berechnet den Mittelwert jeder Spalte
% (one_vector * D) berechnet die Summe jeder Spalte
d_mean = (one_vector * D) / n;

% von jedem Wert in D wird der Mittelwert seiner Spalte abgezogen 
% c_mean(one_vector, :) dubliziert die 
D_substract_mean = D - d_mean(one_vector, :);

% berechnet die Kovarianzmatrix
C = (D_substract_mean.' * D_substract_mean) / (n - 1);

end

