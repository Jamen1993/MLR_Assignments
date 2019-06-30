function par = Exercise1(k)

    % Load control input and motion output data
    load("Data");

    % Divide dataset for k-fold cross validation
    n = length(Input);

    Input = reshape(Input, 2, [], k);
    Output = reshape(Output, 3, [], k);

    nset = size(Input, 2);

    % Estimate parameters
    %
    % The model maps velocity and angular speed of rotation (in the robot's coordinate system) to position and orientation (in the world coordinate system). Position and rotation have to be processed separately since their model complexities are independent and can thus be different.
    %
    % The mapping function is a1 + a2 * v + a3 * w + a4 * v * w + a5 * v² + a6 * w² + a * (v * w)² + ... where the highest power is determined by the model complexity. The mapping function can be split in parameter vector theta and regressor matrix with y = regressors * theta.

    function regressors = make_regressor_matrix(ii_training, p)

        regressors = [ones(nset * length(ii_training), 1), zeros(nset * length(ii_training), 3 * p)];

        for itp = 1 : p

            regressors(:, (1 : 3) + 1 + 3 * (itp - 1)) = [vec(Input(1, :, ii_training)) .^ itp, vec(Input(2, :, ii_training)) .^ itp, (vec(Input(1, :, ii_training)) .* vec(Input(2, :, ii_training))) .^ itp];

        end

    end

    % Position test error
    pos_error = zeros(6, 1);
    % Orientation test error
    ori_error = zeros(6, 1);

    % Iterate over model complexity
    for p = 1 : 6

        % Estimated output for the test fold by applying the estimated parameters
        estimated_output = zeros(nset, k, 3);

        % Iterate over cross validation folds, the set that should be the test set
        for K = 1 : k
            % Folds for parameter estimation
            ii = setdiff(1 : k, K);

            regressors = make_regressor_matrix(ii, p);

            % Estimate parameters with the training sets
            theta = regressors \ reshape(Output(:, :, ii), 3, [])';

            % Estimate output for the test set
            estimated_output(:, K, :) = make_regressor_matrix(K, p) * theta;
        end

        estimated_output = reshape(estimated_output, [], 3);

        % Compute position and orientation errors
        pos_error(p) = mean(sqrt(sum((reshape(Output(1 : 2, :, :), 2, [])' - estimated_output(:, 1 : 2)) .^ 2, 2)));
        ori_error(p) = mean(reshape(Output(3, :, :), 1, [])' - estimated_output(:, 3));
    end

    % Determine optimal (by means of smallest test error) model complexities
    [~, p1] = min(pos_error);
    [~, p2] = min(ori_error);

    % Do final parameter estimation by using all training data, no division in folds
    %
    % Position
    regressors = make_regressor_matrix(1 : k, p1);

    theta = regressors \ reshape(Output(1 : 2, :, :), 2, [])';

    par{1} = theta(:, 1);
    par{2} = theta(:, 2);

    % Orientation
    regressors = make_regressor_matrix(1 : k, p2);

    theta = regressors \ reshape(Output(3, :, :), 1, [])';

    par{3} = theta;
end
