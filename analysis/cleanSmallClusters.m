function [ clean_brain ] = cleanSmallClusters( brain, minimal_cluster_size, cluster_numbers )
%the function receives a binary brain and removes too little clusters. use
%cluster_numbers to mark each cluster with an integer (instead of a binary
%mask

if nargin<3
    cluster_numbers = 0;
end

CC = bwconncomp(brain,18);
clusters = CC.PixelIdxList;
clean_brain = zeros(size(brain));
num_of_clusters = 0;
for cluster_ind = 1:length(clusters);
    if length(clusters{cluster_ind}) > minimal_cluster_size
        clean_brain(clusters{cluster_ind}) = 1+cluster_numbers*num_of_clusters;
        num_of_clusters = num_of_clusters+1;
    end
end
end

