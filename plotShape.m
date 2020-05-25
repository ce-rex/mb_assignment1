function [] = plotShape(mode, mean_shapes, std_shape, mode_number)
%PLOTSHAPE Plots shapes (blue) and mean shape (red)

if ~exist('mode_number','var')
    mode_number = '';
end

xlimPlot = [-100, 100];
ylimPlot = [-180, 170];

figure()
hold on

for i=1:7
    if i ~= 4
        subplot(1, 7, i);
        standardSubPlotShape(mode, mean_shapes, std_shape, xlimPlot, ylimPlot, i-4);
    else
        subplot(1, 7, 4);
        scatter(mean_shapes(:, 1), mean_shapes(:, 2), [], 'red');
        xlim(xlimPlot);
        ylim(ylimPlot);
        title('Mean Shape');
    end
    
sgtitle(strcat('Mode number', {' '}, num2str(mode_number)));

hold off;

end

