function exercise3_doc

    load("gesture_dataset");

    fh_l = Exercise3_kmeans(gesture_l, init_cluster_l, 7);
    fh_o = Exercise3_kmeans(gesture_o, init_cluster_o, 7);
    fh_x = Exercise3_kmeans(gesture_x, init_cluster_x, 7);

    print_figure(fh_l, "Assignment_1/out/kmeans_l");
    print_figure(fh_o, "Assignment_1/out/kmeans_o");
    print_figure(fh_x, "Assignment_1/out/kmeans_x");

    close([fh_l, fh_o, fh_x]);

    fh_l = Exercise3_nubs(gesture_l, 7);
    fh_o = Exercise3_nubs(gesture_o, 7);
    fh_x = Exercise3_nubs(gesture_x, 7);

    print_figure(fh_l, "Assignment_1/out/nubs_l");
    print_figure(fh_o, "Assignment_1/out/nubs_o");
    print_figure(fh_x, "Assignment_1/out/nubs_x");

    close([fh_l, fh_o, fh_x]);

end
