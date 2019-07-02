function fh = Exercise3_nubs(data, nclusters)

    % Rearrange data by merging repetitions of the same gesture
    data = reshape(data, [], 3)';

    % Initialise cluster centers with one center that is the mean of all data
    centers = mean(data, 2);

    % Shift after split vector
    v = [0.08
         0.05
         0.02];

    % Iterate over clusters (number after split)
    for it = 2 : nclusters

        % Differentiate case of only one cluster
        if it >= 3
            % Compute cluster distortion with euclidian distance
            distortion = zeros(size(centers, 2), 1);

            % Iterate over clusters
            for it_cluster = 1 : size(centers, 2)

                distortion(it_cluster) = sum(vecnorm(data(:, cluster_assignment == it_cluster) - centers(:, it_cluster)));

            end

            % Find cluster with largest distortion
            [~, ii] = max(distortion);
        else
            ii = 1;
        end


        % and split it
        centers = [centers, centers(:, ii) + [v, -v]];
        centers(:, ii) = [];

        % Assign data to clusters by finding the closest center
        %
        % Compute euclidian distance between centers and data points
        d = squeeze(vecnorm(data - permute(centers, [1, 3, 2])));

        % Assign data points to cluster of nearest center
        [~, cluster_assignment] = min(d, [], 2);

        % Compute new center by taking the mean of all associated data points
        for it_cluster = 1 : size(centers, 2)

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
