function [d] = compute_correlation(h1, H2)
    %H2 may be a collection of column histos
    h1_bar = sum(h1, 1) ./ size(h1,1);
    H2_bar = sum(H2, 1) ./ size(H2,1);

    %Divide the originial equation into quadrants 
    q1 = h1 - h1_bar;
    q2 = H2 - repmat(H2_bar, [size(H2,1), 1]);
    
    %Basically, dot product of every column of q2 w/ q1
    q1_repeated = repmat(q1, [1, size(H2,2)]);
    nums = dot(q1_repeated, q2, 1); % To produce a row vector of sum(q1*q2) for every candidate q2
    
    q3 = sum( (h1 - h1_bar).^2, 1) .^ .5;
    q4 = sum( (H2 - repmat(H2_bar, [size(H2,1), 1])).^2, 1) .^ .5;
    denoms = q4 .* q3;
    d = (denoms .^ -1) .* nums;
end