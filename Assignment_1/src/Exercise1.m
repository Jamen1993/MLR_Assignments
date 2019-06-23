function par = Exercise1(k)

    % Load control input and motion output data
    load("Data");

    %% Divide dataset for k-fold cross validation
    Input = reshape(Input, 2, [], k);
    Output = reshape(Output, 3, [], k);

    nset = size(Input, 2);

    %% Estimate parameters for cartesian position

    % The model maps velocity and angular speed of rotation (in the robot's coordinate system) to position and orientation (in the world coordinate system). Position and rotation have to be processed separately since their model complexities are independent.

    % Model complexity for cartesian position
    p1 = 3;

    function regressors = make_regressor_matrix(indices)

        regressors = [ones(nset * length(indices), 1), zeros(nset * length(indices), 3 * p1)];

        for itp = 1 : p1

            regressors(:, (1 : 3) + 1 + 3 * (itp - 1)) = [vec(Input(1, :, indices)) .^ itp, vec(Input(2, :, indices)) .^ itp, (vec(Input(1, :, indices)) .* vec(Input(2, :, indices))) .^ itp];

        end

    end

    while true

        % The mapping function is a1 + a2 * v + a3 * w + a4 * v * w + a5 * v² + a6 * w² + a * (v * w)² + ... where the highest power is determined by the model complexity. The mapping function can be split in parameter vector theta and regressor matrix with y = regressors * theta.

        pos_error = zeros(k, 1);

        % Iterate over cross validation folds, the set that should be the test set
        for K = 1 : k
            ii = setdiff(1 : k, K);

            regressors = make_regressor_matrix(ii);

            % Estimate parameters
            theta = regressors \ reshape(Output(1 : 2, :, ii), 2, [])';

            % Compute position error for the current fold
            estimated_output = make_regressor_matrix(K) * theta;

        end


        break;
    end
end
