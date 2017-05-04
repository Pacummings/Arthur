function trackingTester(data_params, tracking_params)
close all;
% create initial image
file = data_params.genFname(1);
in_path = [data_params.data_dir, '/', file];
img = imread(in_path);
xmin = tracking_params.rect(1);
ymin = tracking_params.rect(2);
width = tracking_params.rect(3);
height = tracking_params.rect(4);
% get template image
rgbImgTemp = img(ymin:(ymin+height), xmin:(xmin+width),:); % rect: [xmin ymin width height]
%imshow(rgbImgTemp);
[ind_img, map] = rgb2ind(rgbImgTemp, tracking_params.bin_n);
% generate histogram for the template
templateHist = histcounts(ind_img,tracking_params.bin_n);

% set up some variables
winSize = tracking_params.search_half_window_size;

% loops through all the images
for i = 1:length(data_params.frame_ids)
    % reads in image
    file = data_params.genFname(i);
    in_path = [data_params.data_dir, '/', file];
    out_path = [data_params.out_dir, '/', file];
    img = imread(in_path);
    
    % generate image for entire search window
    searchImg = img((ymin-winSize):(ymin+height+winSize), (xmin-winSize):(xmin+width+winSize),:);
    
    % convert to histogram image
    searchIndImg = rgb2ind(searchImg, map); % uses the same map
    colImg = im2col(searchIndImg, [width, height]);
    searchHists = zeros(size(colImg,2),tracking_params.bin_n);
    for j = 1:size(colImg,2)
        searchHists(j,:) = histcounts(colImg(:,j),tracking_params.bin_n);
    end
    
    % find max correlation between data and template histogram
    h1_avg = sum(templateHist)/ size(templateHist,2);
    H2_avg = sum(searchHists, 2) ./ size(searchHists,2);

    %Divide the originial equation into quadrants 
    q1 = h1 - h1_bar;
    q2 = H2 - repmat(H2_bar, [size(H2,1), 1]);
    
    %Basically, dot product of every column of q2 w/ q1
    q1_repeated = repmat(q1, [1, size(H2,2)]);
    nums = dot(q1_repeated, q2, 1); % To produce a row vector of sum(q1*q2) for every candidate q2
    
    q3 = sqrt(sum((templateHist - h1_avg).^2));
    q4 = sqrt(sum((searchHists - H2_avg).^2),2);
    correlations = numerator./denominator %d = (denoms .^ -1) .* nums;
    
    
    % draw box around tracked object and save image
    color = [0,240,0]; thickness = 3;
    rect = [x_img, y_img, width_img, height_img];
    annotatedImg = drawBox(img, rect, color, thickness);
    imwrite(annotatedImg, out_path);
end