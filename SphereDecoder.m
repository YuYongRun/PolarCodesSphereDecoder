function [d_optimal, d, r0, num_leaf, P, P_aux, complexity] = SphereDecoder(d_index, FNA, P_index, P, P_aux, d, d_optimal, r0, y_reverse, r_lb, num_leaf, complexity)
for i = 1 : 2
    if i == 1
        [d(d_index), P(end - d_index + 1), P_aux(end - d_index + 1)] = select_output_bits(P_index(end - d_index + 1, 1), P_index(end - d_index  + 1, 2), y_reverse, FNA, d, d_index);
        complexity = complexity + 2 * (P_index(end - d_index  + 1, 2) - P_index(end - d_index + 1, 1) + 1);%复杂度统计
    else
        d(d_index) = mod(d(d_index) + 1, 2);
        P(end - d_index + 1) =  P_aux(end - d_index + 1);
    end
    
    if sum(P(1 : end - d_index + 1)) > r0^2 - sum(r_lb(end - d_index + 2 : end))%2015年的论文中的当前半径缩小方法，去掉r0^2后面的减号，复杂度会变高
        continue;
    else
        if d_index == 1
            num_leaf = num_leaf + 1;%每到达一次叶节点，计数一次。如果一次译码结束时num_leaf仍时0，证明初始半径过小，淘汰了所有的码字，需要扩大半径再次译码
            d_optimal = d;%码字更新
            r0 = sqrt(sum(P));%半径更新
        else
            [d_optimal, d, r0, num_leaf, P, P_aux, complexity] = SphereDecoder(d_index - 1, FNA, P_index, P, P_aux, d, d_optimal, r0, y_reverse, r_lb, num_leaf, complexity);
        end
    end
end

end



