function [  ] = computeCorrelations( ws )

%the function takes as input a ws object and computes the correlations
%between the red and blue references, and the seed.

%create three empty correlation vectors
[   ws.TCA.correlations.seed_red, ...
    ws.TCA.correlations.seed_blue, ...
    ws.TCA.correlations.red_blue] = deal(nan(size(ws.images.relevant_voxels)));

%open figure
voxels_scatter = figure('units','centimeters', 'Position', [0, 0, 13, 13],...
    'MenuBar', 'none', 'Color',[1, 1, 1]);
hold on;
xlabel(sprintf('red (%s) correlation', ws.TCA.red_dimension));
ylabel(sprintf('blue (%s) correlation', ws.TCA.blue_dimension));
xlim([-1 1]); ylim([-1 1]);
plot([0,1],[0,1],'black');
plot([-1 1], [0 0],'black');
plot([0 0], [-1 1],'black');
xticks(-1:0.5:1);
yticks(-1:0.5:1);
hold on;


%% MAIN LOOP
%run over voxels and compute correlations
last_plotted_voxel=0;
for i = 1:length(ws.images.relevant_voxels)
    
    %extract voxel's time series
    seed_ts = ws.images.seed(i,:)';
    red_ts = ws.images.red(i,:)';
    blue_ts = ws.images.blue(i,:)';
    
    
    if (std(seed_ts) == 0) || (std(red_ts) == 0) || (std(blue_ts) == 0)
        ws.TCA.correlations.seed_red(i)         = 0;
        ws.TCA.correlations.seed_blue(i)        = 0;
        ws.TCA.correlations.red_blue(i)         = 0;
    else
        ws.TCA.correlations.seed_red(i)         = corr(seed_ts, red_ts);
        ws.TCA.correlations.seed_blue(i)        = corr(seed_ts, blue_ts);
        ws.TCA.correlations.red_blue(i)         = corr(red_ts, blue_ts);
    end
    
    if mod(i, 500) ==0 || i==length(ws.images.relevant_voxels)
        figure(voxels_scatter);
        xlabel(sprintf('red (%s) correlation', ws.TCA.red_dimension));
        ylabel(sprintf('blue (%s) correlation', ws.TCA.blue_dimension));
        xlim([-1 1]); ylim([-1 1]);
        plot([0,1],[0,1],'black');
        plot([-1 1], [0 0],'black');
        plot([0 0], [-1 1],'black');
        xticks(-1:0.5:1);
        yticks(-1:0.5:1);
        scatter(ws.TCA.correlations.seed_red(last_plotted_voxel+1:i),...
            ws.TCA.correlations.seed_blue(last_plotted_voxel+1:i),...
            50, 'MarkerFaceColor','black',...
            'MarkerEdgeColor','black', 'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2);
        last_plotted_voxel=i;
        title(sprintf('%d out of %d total voxels' , i, length(ws.images.relevant_voxels)));
        drawnow();
    end
end
end

