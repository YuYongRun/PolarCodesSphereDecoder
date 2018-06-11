function [r_lb, min_metric] = get_lower_bound_and_min_metric(P_index, y_reverse)
K = size(P_index, 1);
r_lb = zeros(K - 1, 1);
for i = 1 : K - 1
    lb = 0;
    for j = P_index(i + 1, 1) : P_index(i + 1, 2)
        lb = lb + min([(0.5*(y_reverse(j) + 1))^2 (0.5*(y_reverse(j) + 1) - 1)^2]);
    end
    r_lb(i) = lb;
end
min_metric = 0;
for j = P_index(1, 1) : P_index(1, 2)
    min_metric = min_metric + min([(0.5*(y_reverse(j) + 1))^2 (0.5*(y_reverse(j) + 1) - 1)^2]);
end
min_metric = min_metric + sum(r_lb);
end