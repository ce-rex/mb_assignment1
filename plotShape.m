function [] = plotShape(mode, mean_shapes, std_shape, mode_number)
%PLOTSHAPE Plots shapes (blue) and mean shape (red)

if ~exist('mode_number','var')
    mode_number = '';
end

hold on;
figure();

subplot(1, 7, 1);
reconstructed_mode1 = mode * (-3)*std_shape + mean_shapes;
scatter(reconstructed_mode1(:, 1), reconstructed_mode1(:, 2));
title('-3{\lambda}');

subplot(1, 7, 2);
reconstructed_mode2 = mode * (-2)*std_shape + mean_shapes;
scatter(reconstructed_mode2(:, 1), reconstructed_mode2(:, 2));
title('-2{\lambda}');

subplot(1, 7, 3);
reconstructed_mode3 = mode * (-1)*std_shape + mean_shapes;
scatter(reconstructed_mode3(:, 1), reconstructed_mode3(:, 2));
title('-1{\lambda}');

subplot(1, 7, 4);
scatter(mean_shapes(:, 1), mean_shapes(:, 2), [], 'red');
title('Mean Shape');

subplot(1, 7, 5);
reconstructed_mode1 = mode * (1)*std_shape + mean_shapes;
scatter(reconstructed_mode1(:, 1), reconstructed_mode1(:, 2));
title('1{\lambda}');

subplot(1, 7, 6);
reconstructed_mode2 = mode * (2)*std_shape + mean_shapes;
scatter(reconstructed_mode2(:, 1), reconstructed_mode2(:, 2));
title('2{\lambda}');

subplot(1, 7, 7);
reconstructed_mode3 = mode * (3)*std_shape + mean_shapes;
scatter(reconstructed_mode3(:, 1), reconstructed_mode3(:, 2));
title('3{\lambda}');

sgtitle(strcat('Mode number', {' '}, num2str(mode_number)));

hold off;

end

