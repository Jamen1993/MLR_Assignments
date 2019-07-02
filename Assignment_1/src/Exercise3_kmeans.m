function fh = Exercise3_kmeans(data, init_centers, nclusters)

    % Rearrange data by merging repetitions of the same gesture
    data = reshape(data, [], 3)';

    % Cluster centers
    centers = init_centers';
    % Previous value of the distortion metric
    prev_distortion = inf;

    while true

        % Assign data to clusters by finding the closest center
        %
        % Compute squared euclidian distance between centers and data points
        d = squeeze(sum((data - permute(centers, [1, 3, 2])) .^ 2, 1));

        % Assign data points to cluster of nearest center
        [~, cluster_assignment] = min(d, [], 2);

        % Compute total distortion with euclidian distance
        distortion = sum(vecnorm(data - centers(:, cluster_assignment)));

        if prev_distortion - distortion < 1e-6
            break;
        end

        prev_distortion = distortion;

        % Compute new center by taking the mean of all associated data points
        for it_cluster = 1 : nclusters

            centers(:, it_cluster) = mean(data(:, cluster_assignment == it_cluster), 2);

        end
    end

    % Plot clusters in x-y 2D projection
    fh = figure;

    colours = ["b", "k", "r", "g", "m", "y", "c"];

    for it_cluster = 1 : nclusters

        this_data = data(:, cluster_assignment == it_cluster);

        plot(this_data(1, :), this_data(2, :), colours(it_cluster) + ".");

        hold on;

    end

    hold off;

    grid on;

end
