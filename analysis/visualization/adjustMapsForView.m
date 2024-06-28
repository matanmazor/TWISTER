function [ stats_map ] = adjustMapsForView( structural, red_map,...
    blue_map, FDR_red_map, FDR_blue_map)


%% set colors

red_rgb = [243, 23, 23];
blue_rgb = [0, 112, 255];
ref_rgb = [0, 0, 0];

%% obtain five 4d (3d*color) maps
map_cell = {structural                      [1,1,1]
    red_map,                      -0.3/255 * (255-red_rgb);...
    blue_map,                     -0.3/255 * (255-blue_rgb);...
    FDR_red_map,            -0.6/255 * (255-red_rgb);...
    FDR_blue_map,           -0.6/255 * (255-blue_rgb)};
stats_map = [];
for i = 1:size(map_cell,1)
    cur_map = abs(map_cell{i,1});
    cur_map(isnan(cur_map(:))) = 0;
    cur_map(isinf(cur_map(:))) = max(cur_map(~isinf(cur_map(:))));
    cur_map = (double(cur_map-min(cur_map(:))))/...
        max(max(double(cur_map(:)-min(double(cur_map(:))))),eps);
    weights = map_cell{i,2};
    cur_map = cat(4, cur_map*weights(1), cur_map*weights(2), cur_map*weights(3));
    stats_map = cat(5,stats_map,cur_map);
end

%% sum maps
stats_map = sum(stats_map,5);
%  discard negative values
stats_map = max(stats_map,0);
end



