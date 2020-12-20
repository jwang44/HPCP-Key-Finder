% script to plot the global HPCP for one audio file
clear; close;
% parameters definition

N = 4096;   %window size
H = 512;    %hop size, as given by Gomez

% 3 audio files to choose from
% MIDI-synthsized, Piano Recording, Cello Recording respectively
[x, Fs] = audioread('./test_audio/Sonata-Hob.XVI-17_Movement-1-Hob.XVI-17_Haydn-Joseph_file1_Bb.wav');
% [x, Fs] = audioread('./test_audio/BachInvention01_C.wav');
% [x, Fs] = audioread('./test_audio/CelloSuite2ii_d.wav');

x = x(:,1);
x = x(find(x,1,'first'):find(x,1,'last')); % remove leading and trailing zeros

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
%Y = 10 * log10(Y);

% HPCP calculation
% only consider a certain freq range
fmin = 100; fmax=5000;
fpmin = round(fmin/(Fs/N)); fpmax = round(fmax/(Fs/N));
Y = Y(fpmin:fpmax, :);

% 36 HPCP bins
size = 36;
n = (1:size);
fref = 440;     % 440Hz, midi69 A as reference
hpcp_bins = fref * 2 .^ (n/size);

% get peaks of the spectrum for each frame
l = 4/3;    % length of weighting window
hpcp = zeros(size, M);
for m=1:M
    % for every frame
    y = Y(:,m);
    y(y<0.00001)=0;
    [pks, locs] = findpeaks(y);

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
ax = (0:35);
plot(ax,hpcp_m);
grid
xticks(0:1:35);
xticklabels({'A','','','A#','','','B','','','C','','','C#','','','D','','','D#','','','E','','','F','','','F#','','','G','','','G#','',''})
%imagesc(hpcp)
%mesh(t,f,Y);
%xlim([0 (M-1)*H/Fs])
%ylim([fmin fmax])
%imagesc( t,f,Y ); %plot the log spectrum
% colorbar
%set(gca,'YDir', 'normal'); 