function [triplet] = makeTCATriplet( blue_dim, red_dim )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

triplet = figure('units','normalized', 'Position', [0.8, 0.7, 0.15, 0.22],...
    'MenuBar', 'none', 'Color', [1, 1, 1]);
set(triplet,'NumberTitle', 'off')
hold on;
plot([0,1,2], [0, sqrt(3), 0], 'black', 'lineWidth', 4);
scatter([0,1,2], [0, sqrt(3), 0],3*10^3, 'MarkerFaceColor','black','MarkerEdgeColor','black');
scatter(0,0,2.4*10^3, 'MarkerFaceColor',[0, 112, 255]/255,'MarkerEdgeColor','black');
scatter(1,sqrt(3),2.4*10^3, 'MarkerFaceColor','white','MarkerEdgeColor','black');
scatter(2,0,2.4*10^3, 'MarkerFaceColor',[243, 23, 23]/255,'MarkerEdgeColor','black');
xlim([-0.3 2.3]); ylim([-0.3 0.3+sqrt(3)]);
set(gca,'xtick',[],'ytick',[])
axis equal
axis off
bd = text(0,0.6,blue_dim);
rd = text(1.6, 1.25, red_dim);
set(bd,'rotation',60);
set(rd, 'rotation', -60);

end

