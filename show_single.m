% script to plot the correlations with key profiles for a single audio file
clear; close;

% 3 audio files to choose from
% MIDI-synthsized, Piano Recording, Cello Recording respectively
f = './test_audio/Sonata-Hob.XVI-17_Movement-1-Hob.XVI-17_Haydn-Joseph_file1_Bb.wav';
%f = './test_audio/BachInvention01_C.wav';
%f = './test_audio/CelloSuite2ii_d.wav';

N = 4096;
H = 512;

hpcp_m = get_hpcp(f, N, H);
K = get_profile();

R = zeros(2,12);

for m=1:2
    for n=1:12
        p = squeeze(K(m,n,:));
        R(m,n)=corr(hpcp_m, p);
    end
end

% plot the results
ax = 0:11;

subplot(2,1,1)
plot(ax, R(1,:)); xlim([0,11]); ylim([-1,1]); grid; title('Correlation with Major Profiles')
xticks(0:11);
xticklabels({'A','A#','B','C','C#','D','D#','E','F','F#','G','G#'})

if max(R(1,:))>=max(R(2,:))
    [tonalness, loc] = max(R(1,:));
    hold on;
    plot(loc-1,tonalness,'o','MarkerSize',10);
end

subplot(2,1,2)
plot(ax, R(2,:)); xlim([0,11]); ylim([-1,1]); grid; title('Correlation with Minor Profiles')
xticks(0:11);
xticklabels({'A','A#','B','C','C#','D','D#','E','F','F#','G','G#'})

if max(R(1,:))<max(R(2,:))
    [tonalness, loc] = max(R(2,:));
    hold on;
    plot(loc-1,tonalness,'o','MarkerSize',10);
end