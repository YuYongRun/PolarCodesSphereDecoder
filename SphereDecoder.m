function [d_optimal, d, r0, num_leaf, P, P_aux, complexity] = SphereDecoder(d_index, FNA, P_index, P, P_aux, d, d_optimal, r0, y_reverse, r_lb, num_leaf, complexity)
for i = 1 : 2
    if i == 1
        [d(d_index), P(end - d_index + 1), P_aux(end - d_index + 1)] = select_output_bits(P_index(end - d_index + 1, 1), P_index(end - d_index  + 1, 2), y_reverse, FNA, d, d_index);
        complexity = complexity + 2 * (P_index(end - d_index  + 1, 2) - P_index(end - d_index + 1, 1) + 1);%���Ӷ�ͳ��
    else
        d(d_index) = mod(d(d_index) + 1, 2);
        P(end - d_index + 1) =  P_aux(end - d_index + 1);
    end
    
    if sum(P(1 : end - d_index + 1)) > r0^2 - sum(r_lb(end - d_index + 2 : end))%2015��������еĵ�ǰ�뾶��С������ȥ��r0^2����ļ��ţ����ӶȻ���
        continue;
    else
        if d_index == 1
            num_leaf = num_leaf + 1;%ÿ����һ��Ҷ�ڵ㣬����һ�Ρ����һ���������ʱnum_leaf��ʱ0��֤����ʼ�뾶��С����̭�����е����֣���Ҫ����뾶�ٴ�����
            d_optimal = d;%���ָ���
            r0 = sqrt(sum(P));%�뾶����
        else
            [d_optimal, d, r0, num_leaf, P, P_aux, complexity] = SphereDecoder(d_index - 1, FNA, P_index, P, P_aux, d, d_optimal, r0, y_reverse, r_lb, num_leaf, complexity);
        end
    end
end

end



