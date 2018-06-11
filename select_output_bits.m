function [output_bit, better_metric, worse_metric] = select_output_bits(a, b, y, FNA, d, bit_index)
P0 = 0;
d(bit_index) = 0;
% P0 = sum( (0.5 * (y(a : b) + 1) -  mod(d'*FNA(:, a : b), 2) ).^2 );
for i = a : b
    P0 = P0 + (0.5*(y(i) + 1) - mod(d'*FNA(:, i), 2) )^2;
end
P1 = 0;
d(bit_index) = 1;
% P1 = sum( (0.5 * (y(a : b) + 1) -  mod(d'*FNA(:, a : b), 2) ).^2 );
for i = a : b
    P1 = P1 + (0.5*(y(i) + 1) - mod(d'*FNA(:, i), 2) )^2;
end
if P0 < P1
    output_bit = 0;
    better_metric = P0;
    worse_metric = P1;
else
    output_bit = 1;
    better_metric = P1;
    worse_metric = P0;
end
end

%注意，单位复杂度的定义是(0.5*(y(i) + 1) - mod(d'*FNA(:, i), 2) )^2，
%即一个(yi - xi)^2算一个复杂度，这个计算是球形译码器的基本计算单元。
%因此，本函数的复杂度为2*(b - a + 1)
%这是因为两个for都执行了，每个for循环b - a + 1次
%因为复杂度仅由a b 决定，而且a b 是输入参数，所以不用真的执行本函数就能获得复杂度
%我把复杂度的统计写在了SphereDecoder.m中