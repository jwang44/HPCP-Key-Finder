function [estm, tonalness] = estm_key(f)
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

% Major key labels
Mlbs = ["A","A#","B","C","C#","D","D#","E","F","F#","G","G#"];
% Minor key labels
mlbs = ["a","a#","b","c","c#","d","d#","e","f","f#","g","g#"];

if max(R(1,:))>=max(R(2,:))
    [tonalness, loc] = max(R(1,:));
    estm = Mlbs(loc);
else
    [tonalness, loc] = max(R(2,:));
    estm = mlbs(loc);
end
end