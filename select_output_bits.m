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

%ע�⣬��λ���ӶȵĶ�����(0.5*(y(i) + 1) - mod(d'*FNA(:, i), 2) )^2��
%��һ��(yi - xi)^2��һ�����Ӷȣ���������������������Ļ������㵥Ԫ��
%��ˣ��������ĸ��Ӷ�Ϊ2*(b - a + 1)
%������Ϊ����for��ִ���ˣ�ÿ��forѭ��b - a + 1��
%��Ϊ���ӶȽ���a b ����������a b ��������������Բ������ִ�б��������ܻ�ø��Ӷ�
%�ҰѸ��Ӷȵ�ͳ��д����SphereDecoder.m��