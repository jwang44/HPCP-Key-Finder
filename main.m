% main script used to generate key estimation results on an entire dataset
% for a folder with many pieces, it runs for a while
clear; close;

% specify the path to dataset
% can directly test on the test_audio folder
Path = './test_audio/';

% get all file names and paths
File = dir(fullfile(Path,'*.wav'));  
FileNames = {File.name}';

% write results into a text file
fileID = fopen('result_test.txt','w');

for n=1:length(FileNames)
    disp(n);
    f = strcat(Path, FileNames{n});
    [estm, tn] = estm_key(f);
    
    fn = split(f, "/"); fn = fn(end);
    fn = split(fn, "."); fn = fn(end-1); 
    fn = char(fn);
    gt = split(fn, "_"); gt = gt(end);  % ground truth
    gt = char(gt);
    fprintf(fileID,'%80s %4s %4s %8f\n',fn, gt, estm, tn);
end

fclose(fileID);