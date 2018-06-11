function [bler, ber] = simulation(N, K, design_epsilon, max_runs, max_err, ebno_vec)
R = K/N;

%Bhattacharyya Code Construction
% channels = get_BEC_IWi(N, design_epsilon);
% [~, channel_ordered] = sort(channels, 'descend');
% info_bits = sort(channel_ordered(1 : K), 'ascend');

%GA
design_snr = 6;
sigma_cc = 1/sqrt(2 * R) * 10^(-design_snr/20);
[channels, ~] = GA(sigma_cc, N);
[~, channel_ordered] = sort(channels, 'descend');
info_bits = sort(channel_ordered(1 : K));


%Sphere Decoding parameters
FN = get_FN(N);
G = FN(info_bits, :);% rows in FN acssociated with information bits
FNA = G(:, N : -1 : 1);
P_index = get_P_index(FNA);


%Results Stored
bler = zeros(length(ebno_vec), 1);
ber = zeros(length(ebno_vec), 1);
num_runs = zeros(length(ebno_vec), 1);
complexity = zeros(length(ebno_vec), 1);
tic
for i_run = 1 : max_runs

    if  mod(i_run, max_runs/10000) == 1
        disp(' ');
        disp(['Standard Sphere decoder running = ' num2str(i_run)]);
        disp(['N = ' num2str(N)  ' K = ' num2str(K)  ' GA snr = ' num2str(design_snr) 'dB'])
        disp('Current block error performance');
        disp(num2str([ebno_vec'  bler./num_runs]));
        disp('Current bit error performance');
        disp(num2str([ebno_vec' ber./num_runs/K]));
        disp('Current Average complexity')
        disp(num2str([ebno_vec' complexity./num_runs]))
        disp(' ');
    end
    %To avoid redundancy
    info  = rand(1, K) > 0.5;
    x = mod(info * G, 2);
    bpsk = 2 * x - 1;  %1 ¡ú +1, 0 ¡ú -1
    noise = randn(1, N);
    prev_decoded = zeros(1, length(ebno_vec));
    for i_ebno = 1 : length(ebno_vec)
        sigma = 1/sqrt(2 * R) * 10^(-ebno_vec(i_ebno)/20);
        y = bpsk + sigma * noise;
        
        if bler(i_ebno) == max_err
            continue;
        end
        num_runs(i_ebno) = num_runs(i_ebno) + 1;
        
        run_sim = 1;
        
        for i_ebno2 = 1 : i_ebno
            if prev_decoded(i_ebno2)
                run_sim = 0;
            end
        end
        
        if (run_sim == 0)
            % This is a hack to speed up simulations --
            % it assumes that this run will be decoded correctly since it was
            % decoded correctly for a lower EbNo
            continue;
        end

        num_leaf = 0;
        P = zeros(K ,1);
        P_aux = zeros(K ,1);
        d = zeros(K ,1);
        d_optimal = zeros(K ,1);
        y_reverse = y(end : -1 : 1);
        [r_lb, min_metric] = get_lower_bound_and_min_metric(P_index, y_reverse);
        r = min_metric;
        complexity_one_time = 0;
        while(num_leaf == 0)
            r = r + 1;
            r0 = sqrt(r);
            [d_optimal, ~, ~, num_leaf, ~, ~, complexity_one_time] = SphereDecoder(K, FNA, P_index, P, P_aux, d, d_optimal, r0, y_reverse, r_lb, num_leaf, complexity_one_time);
        end
        complexity(i_ebno) = complexity(i_ebno) + complexity_one_time;

        if any(d_optimal' ~= info)
            bler(i_ebno) = bler(i_ebno) + 1;
            ber(i_ebno) = ber(i_ebno) + sum(d_optimal' ~= info);
        else
            prev_decoded(i_ebno) = 1;
        end
        
    end
end
toc
end

