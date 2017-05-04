function result = computeFlow(img1, img2, win_radius, template_radius, grid_MN)
    samples_x = round((win_radius+1):((size(img1,2)-win_radius*2)/grid_MN(2)):(size(img1, 2)-win_radius));
    samples_y = round((win_radius+1):((size(img1,1)-win_radius*2)/grid_MN(1)):(size(img1, 1)-win_radius));
    px = zeros(1,grid_MN(1)*grid_MN(2));
    py = zeros(1,grid_MN(1)*grid_MN(2));
    xmesh = zeros(1,grid_MN(1)*grid_MN(2));
    ymesh = zeros(1,grid_MN(1)*grid_MN(2));
        
    i = 0;
    for x=samples_x
        for y=samples_y
            i = i + 1;
            square_template = img1((y-template_radius):(y+template_radius), ...
                                   (x-template_radius):(x+template_radius));
            search_space = img2((y-win_radius):(y+win_radius), ...
                                (x-win_radius):(x+win_radius));
            corr = normxcorr2(square_template,search_space);
            [ypeak, xpeak] = find(corr==max(corr(:)));
            if max(corr(:))>.95
                py(i) = ypeak(1) - template_radius - win_radius - 1;
                px(i) = xpeak(1) - template_radius - win_radius - 1;
                ymesh(i) = y;
                xmesh(i) = x;
            end
        end
    end
    fh = figure(1), hold on;
    quiver(xmesh,ymesh,px,py), axis image;
    set (gca, 'Ydir', 'reverse');
    saveas(fh, 'tmp', 'png');
    result = imread('tmp.png');
    clf, hold off;
end