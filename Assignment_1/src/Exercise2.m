function Exercise2(dmax)

    % Load images and labels from MNIST database
    images = loadMNISTImages("train-images.idx3-ubyte");
    labels = loadMNISTLabels("train-labels.idx1-ubyte");

    % Reduce sample dimensionality by performing principal component analysis on images
    %
    % Mean of all images
    mean_images = mean(images, 2);

    % Make images zero mean
    images = images - mean_images;

    % Covariance of zero mean images
    S = cov(images');

    % Find principal components by eigenvalue decomposition (eigenvectors form projection basis)
    [V, ~] = eigs(S, dmax);

    % Project samples onto space spanned by eigenvectors
    images_reduced = V' * images;

    % Model images with multivariate gaussian distribution
    %
    % Mean per class
    m = zeros(dmax, 10);
    % Covariance per class
    S = zeros(dmax, dmax, 10);

    % Iterate over class
    for it = 1 : 10

        % Find images of the class
        class_images = images_reduced(:, labels == (it - 1));

        % Compute mean and covariance
        m(:, it) = mean(class_images, 2);
        S(:, :, it) = cov(class_images');

    end

    % Perform classification with varying number of dimensions on test dataset
    %
    % Load dataset
    test_images = loadMNISTImages("t10k-images.idx3-ubyte");
    test_labels = loadMNISTLabels("t10k-labels.idx1-ubyte");

    % Project samples with zero mean of training data removed
    test_images_reduced = V' * (test_images - mean_images);

    % Classification error over data dimensionality
    class_error = zeros(dmax, 1);

    % Iterate over dimensionality
    for it_d = 1 : dmax

        % Probability of x given class
        p = zeros(10, length(test_images));

        % Iterate over classes
        for it_class = 1 : 10

            % Compute probability for test data with multivariate gaussian distribution
            p(it_class, :) = mvnpdf(test_images_reduced(1 : it_d, :)', m(1 : it_d, it_class)', S(1 : it_d, 1 : it_d, it_class));

        end

        [~, classified_labels] = max(p, [], 1);
        classified_labels = classified_labels - 1;

        confmat = confusionmat(test_labels, classified_labels);

        class_error(it_d) = sum(confmat - diag(diag(confmat)), "all") / length(test_images) * 100;

    end
end
