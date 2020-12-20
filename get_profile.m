function K = get_profile()
% original Krumhansl profile values
%maj = [6.35, 2.23, 3.48, 2.33, 4.38, 4.09, 2.52, 5.19, 2.39, 3.66, 2.29, 2.88];
%min = [6.33, 2.68, 3.52, 5.38, 2.60, 3.53, 2.54, 4.75, 3.98, 2.69, 3.34, 3.17];

% eyeballed values, already normalized
TMp = [0.81, 0, 0.54, 0, 0.52, 0.3, 0.08, 1, 0, 0.36, 0, 0.47];
Tmp = [0.81, 0, 0.52, 0.54, 0, 0.27, 0.08, 1, 0.27, 0.07, 0.09, 0.37];
TMp = interp_profile(TMp);
Tmp = interp_profile(Tmp);

K = zeros(2,12,36);
for n=1:12
    K(1,n,:) = circshift(TMp, 3*(n-1));
    K(2,n,:) = circshift(Tmp, 3*(n-1));
end
end
