function [] = standardSubPlotShape(mode, mean_shapes, std_shape, xlimPlot, ylimPlot, factor)
%PLOTSHAPE Plots shapes (blue) and mean shape (red)

scatter(mean_shapes(:, 1), mean_shapes(:, 2), [], 'red', 'MarkerEdgeAlpha', 0.4);
hold on;
reconstructed_mode1 = mode * factor*std_shape + mean_shapes;
scatter(reconstructed_mode1(:, 1), reconstructed_mode1(:, 2), 'blue');
xlim(xlimPlot);
ylim(ylimPlot);
title(strcat(num2str(factor), '{\lambda}'));

hold off;

end


