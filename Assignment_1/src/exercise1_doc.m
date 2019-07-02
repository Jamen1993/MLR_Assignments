function exercise1_doc

    par2 = Exercise1(2);

    p21 = (length(par2{1}) - 1) / 3;
    p22 = (length(par2{3}) - 1) / 3;

    v = [0, 1, 1, -1, 0.5];
    w = [0.05, 0, 0.05, -0.05, -0.03];

    for it = 1 : length(v)

        Simulate_robot(v(it), w(it), par2);
        print_figure(gcf, "Assignment_1/out/robot_2" + it);
        close(gcf);

    end

    par5 = Exercise1(5);

    p51 = (length(par5{1}) - 1) / 3;
    p52 = (length(par5{3}) - 1) / 3;

    for it = 1 : length(v)

        Simulate_robot(v(it), w(it), par5);
        print_figure(gcf, "Assignment_1/out/robot_5" + it);
        close(gcf);

    end

    save("Assignment_1/out/exercise1_result", "par2", "p21", "p22", "par5", "p51", "p52");
end
