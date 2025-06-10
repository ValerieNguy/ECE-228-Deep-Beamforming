%% -------- Setup --------
BW = params.bandwidth * 1e9; % Hz
num_DL_size_points = 15;
num_sampled_OFDM = size(DeepMIMO_dataset{1}.user{1}.channel, 3);
num_beams = size(BF_codebook, 2);
n_BS = length(params.active_BS);

Pn = -204 + 10 * log10(BW);
SNR = 10^(0.1 * (0 - Pn));

%% -------- Part A: Achievable Rate vs Dataset Size --------
% Load DL outputs and compute achievable rates
ach_rate_DL  = zeros(1, num_DL_size_points);
ach_rate_opt = zeros(1, num_DL_size_points);

for i = 1:num_DL_size_points
    fname = sprintf('DLCB_code_output/DL_Result%d.mat', i);
    load(fname);  % loads user_index, TX1Pred_Beams etc.
    user_indices(i, :) = user_index + 1;

    for t = 1:n_BS
        TX{i, t}.pred_beams = eval(sprintf('TX%dPred_Beams', t));
        TX{i, t}.opt_beams  = eval(sprintf('TX%dOpt_Beams', t));
    end
end

% Compute rates
for i = 1:num_DL_size_points
    for u = 1:size(user_indices, 2)
        for t = 1:n_BS
            ch = squeeze(DeepMIMO_dataset{t}.user{user_indices(i, u)}.channel);
            if i == 1
                beam_idx_pred = randi(num_beams);
            else
                [~, beam_idx_pred] = max(TX{i, t}.pred_beams(u, :));
            end
            [~, beam_idx_opt] = max(TX{i, t}.opt_beams(u, :));

            eff_pred(t,:) = ch' * BF_codebook(:, beam_idx_pred);
            eff_opt(t,:)  = ch' * BF_codebook(:, beam_idx_opt);
        end
        ach_rate_DL(i)  = ach_rate_DL(i)  + sum(log2(1 + SNR * abs(diag(eff_pred' * eff_pred)))) / (size(user_indices, 2) * num_sampled_OFDM);
        ach_rate_opt(i) = ach_rate_opt(i) + sum(log2(1 + SNR * abs(diag(eff_opt'  * eff_opt))))  / (size(user_indices, 2) * num_sampled_OFDM);
    end
end

% Overhead calculations for dataset size
theta_user = (102 / params.num_ant_BS(2)) * pi / 180;
alpha = 60 * pi / 180;
distance_user = 10;
Tc_const = (distance_user * theta_user) / (2 * sin(alpha));
Tt = 10e-6;
v = 50 * 1000 * 1.6 / 3600; % m/s at 50 mph
Tc = Tc_const / v;

overhead_DL  = 1 - Tt / Tc;
overhead_opt = 1 - (num_beams * Tt) / Tc;

% Plot
DL_size_array = 0:2.5:2.5 * (num_DL_size_points - 1);

figure('Name', 'Achievable Rate vs Dataset Size');
plot(DL_size_array, ach_rate_opt, 'k--', 'DisplayName', 'Genie-aided Coordinated BF'); hold on; grid on;
plot(DL_size_array, ach_rate_DL * overhead_DL, 'o-', 'DisplayName', 'DL Coordinated BF', 'Color', '#0072BD');
plot(DL_size_array, ach_rate_opt * overhead_opt, 's-', 'DisplayName', 'Baseline Coordinated BF', 'Color', '#A2142F');
xlabel('Dataset Size (Thousand Samples)');
ylabel('Achievable Rate (bps/Hz)');
legend('Location', 'SouthEast');
savefig('ach_rate_vs_dataset.fig');

%% -------- Part B: Achievable Rate vs Number of Beams at 30/50/70 mph --------
max_beams = size(BF_codebook, 2);
num_beams_list = 100:100:max_beams;
num_cases = length(num_beams_list);

DL_result = load('DLCB_code_output/DL_Result15.mat');
user_indices_beam = DL_result.user_index + 1;
ach_rate_DL_beam   = zeros(1, num_cases);
ach_rate_opt_beam  = zeros(1, num_cases);
ach_rate_rand_beam = zeros(1, num_cases);

for b = 1:num_cases
    B = num_beams_list(b);
    CB = BF_codebook(:, 1:B);
    for u = 1:length(user_indices_beam)
        for t = 1:n_BS
            ch = squeeze(DeepMIMO_dataset{t}.user{user_indices_beam(u)}.channel);
            pred_beams = DL_result.(sprintf('TX%dPred_Beams', t));

            [~, pred_idx] = max(pred_beams(u, 1:B));
            rand_idx = randi(B);

            % Brute-force optimal
            beam_gains = vecnorm(ch' * CB).^2;
            [~, opt_idx] = max(beam_gains);

            eff_DL(t,:)   = ch' * CB(:, pred_idx);
            eff_OPT(t,:)  = ch' * CB(:, opt_idx);
            eff_RAND(t,:) = ch' * CB(:, rand_idx);
        end
        ach_rate_DL_beam(b)   = ach_rate_DL_beam(b)   + sum(log2(1 + SNR * abs(diag(eff_DL'   * eff_DL))))   / (length(user_indices_beam) * num_sampled_OFDM);
        ach_rate_opt_beam(b)  = ach_rate_opt_beam(b)  + sum(log2(1 + SNR * abs(diag(eff_OPT'  * eff_OPT))))  / (length(user_indices_beam) * num_sampled_OFDM);
        ach_rate_rand_beam(b) = ach_rate_rand_beam(b) + sum(log2(1 + SNR * abs(diag(eff_RAND' * eff_RAND)))) / (length(user_indices_beam) * num_sampled_OFDM);
    end
end

% Plot for 3 speeds
speed_list = [30, 50, 70];
colors = lines(length(speed_list));

figure('Name', 'Achievable Rate vs Num Beams (Multiple Speeds)');
plot(num_beams_list, ach_rate_opt_beam, 'k--', 'DisplayName', 'Genie-Aided Coordinated BF'); hold on; grid on;

for s = 1:length(speed_list)
    v = speed_list(s) * 1000 * 1.6 / 3600;
    Tc = Tc_const / v;
    overhead_DL  = 1 - Tt / Tc;
    overhead_opt = 1 - (num_beams_list * Tt) / Tc;

    plot(num_beams_list, ach_rate_DL_beam * overhead_DL, ...
        '-o', 'Color', colors(s,:), 'DisplayName', sprintf('DL BF - %d mph', speed_list(s)));

    plot(num_beams_list, ach_rate_opt_beam .* overhead_opt, ...
        '-s', 'Color', colors(s,:), 'DisplayName', sprintf('Baseline BF - %d mph', speed_list(s)));
end

xlabel('Number of Beams');
ylabel('Effective Achievable Rate (bps/Hz)');
title('Achievable Rate vs Number of Beams at Different Speeds');
legend('Location', 'SouthEast');
savefig('ach_rate_vs_beams.fig');
