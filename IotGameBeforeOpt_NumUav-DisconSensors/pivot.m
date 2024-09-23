function B = pivot(A,r,s)
% Pivots the tableau on the given row and column
    
    [m,~] = size(A);
    B = A;
    
    for i = 1 : m
        if i == r
            continue;
        else
            B(i,:) = A(i,:) - A(i,s) / A(r,s) * A(r,:);
        end
    end
    
end
