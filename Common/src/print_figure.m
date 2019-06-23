function print_figure(fig, filename)
    ratio = 4 / 3;

    w = 30;
    h = w / ratio;

    set(fig, 'PaperOrientation', 'landscape', 'PaperUnits', 'centimeters', 'PaperPosition', [-1 -0.5 w h], 'PaperSize', [w - 2, h - 1]);
    print(filename, '-dpdf');
end
