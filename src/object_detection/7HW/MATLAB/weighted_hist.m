function [bins] = weighted_hist(X, W, bin_n)
    % Make sure we can use the contents as indices... careful of this.
    % I think as long as I'm consistent it's fine
    X = X + 1;

    % Where W is a column vector the same height as X
    bins = zeros(bin_n, size(X, 2));
    
    for r=1:size(X,1)
        for c=1:size(X,2)
            bins(X(r,c), c) = bins(X(r,c),c) + W(r);
        end
    end
    
    % Normalize
    denoms = sum(bins, 1);
    spread_denoms = repmat(denoms.^-1, [ bin_n, 1]);
    bins = bins .* spread_denoms;
end