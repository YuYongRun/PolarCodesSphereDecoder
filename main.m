clear
addpath('GA/')
n = 6;
N = 2^n;
K = 32;
design_epsilon = 0.05;
ebno_vec = [4.5];
max_runs = 1e7;
max_err = 100;
[bler, ber] = simulation(N, K, design_epsilon, max_runs, max_err, ebno_vec);

