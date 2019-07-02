function exercise2_doc

    [fh, dopt, error, confmat] = Exercise2(60);

    print_figure(fh, "Assignment_1/out/classification_error");
    close(fh);

    save("Assignment_1/out/exercise2_result", "dopt", "error", "confmat");

    helperDisplayConfusionMatrix(confmat);
end
