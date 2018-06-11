function P_index = get_P_index(FNA)
N = size(FNA, 2);
K = size(FNA, 1);
k = 2;
n = 1;
P_index = zeros(K, 2);
P_index(1, 1) = 1;

while(n < N)
    if k <= K
        if FNA(K - k + 1, n + 1) == 1
            P_index(k - 1, 2) = n;
            P_index(k, 1) = n + 1;
            n = n + 1;
            k = k + 1;
        else
            n = n + 1; 
        end
    else
        P_index(end, end) = N;
        break;
    end
end

end