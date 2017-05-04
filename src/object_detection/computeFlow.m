function result = computeFlow(img1, img2, win_radius, template_radius, grid_MN)
% for each point in the grid we are going to take a chunk in img 1 of size
% template radius and then search over the 2nd image of size win radius to
% find the one that is maximally correlated and then find the difference.
close all;

% evenly space out point on grid
row_size = grid_MN(1); col_size = grid_MN(2);
low_w = win_radius+1; high_w = size(img1,2) - (win_radius+1);
low_h = win_radius+1; high_h = size(img1,1) - (win_radius+1);

% initialize variables
u = zeros(1,row_size*col_size);
v = zeros(1,row_size*col_size);
x = zeros(1,row_size*col_size);
y = zeros(1,row_size*col_size);

ind = 1;
% loop through each grid pixel
cols = linspace(low_w, high_w, col_size);
rows = linspace(low_h, high_h, row_size);

for i = round(rows)
    for j = round(cols)
        % make template
        tr = template_radius;
        template_img = img1(i-tr:i+tr,j-tr:j+tr);
        
        % make search image;
        wr = win_radius;
        search_img = img2(i-wr:i+wr,j-wr:j+wr);
        % find match
        c = normxcorr2(template_img,search_img);
        [ypeak, xpeak] = find(c==max(c(:)));
        % Compute optical flow
        v(ind) = ypeak(1) - template_radius - win_radius - 1;
        u(ind) = xpeak(1) - template_radius - win_radius - 1;
        x(ind) = j;
        y(ind) = i;
        ind = ind + 1;
    end
end

%show arrows
fh = figure(1); 
imshow(img1); hold on;
quiver(x,y,u,v), axis image;
saveas(fh, 'res', 'png');
result = imread('res.png');