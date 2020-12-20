function hpcp_m = get_hpcp(f, N, H)
if nargin<2
    N = 4096;
end
if nargin<3
    H = 512;
end
[x, Fs] = audioread(f);
x = x(:,1);     % convert to single channel
x = x(find(x,1,'first'):find(x,1,'last'));  % remove the leading and trailing zeros

win = window(@blackmanharris, N);
M = floor((length(x) - N)/H) + 1;   % frame number
X = zeros(N, M);

% spectral analysis
for m=1:M
    x_win = x((m-1)*H+1 : (m-1)*H+N) .* win;
    X_win = fft(x_win);
    % X_win = X_win(1:round(N/2)+1, :);
    X(:,m) = X_win;
end
Y = abs(X);

% HPCP calculation

% only consider a certain freq range
fmin = 100; fmax=5000;
fpmin = round(fmin/(Fs/N)); fpmax = round(fmax/(Fs/N));
Y = Y(fpmin:fpmax, :);

% 36 HPCP bins
size = 36;
n = (1:size);
fref = 440;     % 440Hz, midi69 A as reference
%fref = 450;     % set this to 450 to test cello excerpts with higher tuning
hpcp_bins = fref * 2 .^ (n/size);

% get peaks of the spectrum for each frame
l = 4/3;    % length of weighting window
hpcp = zeros(size, M);
for m=1:M
    % for every frame
%     y = Y(:,m);
%     y(y<0.0001)=0;
%     [pks, locs] = findpeaks(y);
    [pks, locs] = findpeaks(Y(:,m));
    if isempty(pks)
        hpcp(:,m)=zeros(size,1);
        continue
    end
    pks = pks';
    fpks = (locs' + fpmin - 1)*Fs/N;   % freq of peaks
    for n=1:size
        % for every bin
        w = zeros(1,length(fpks));
        % distance between peak freq and bin center freq, in semitones
        %ds = rem(12 * log2(fpks./hpcp_bins(n)), 12);
        d = rem(12 * log2(fpks./hpcp_bins(n)), 12);
        d(d<-6) = d(d<-6)+12;
        d(d>6) = d(d>6)-12;
        % calculate the weight
        w(abs(d)<=0.5*l) = cos(pi/2 * d(abs(d)<=0.5*l)/(0.5*l)).^2;
        hpcp(n, m) = sum(w.*(pks.^2));
    end
    % normalize for each frame
    hpcp(:, m) = hpcp(:, m)./max((hpcp(:,m)));
end
hpcp_m = mean(hpcp, 2);
end