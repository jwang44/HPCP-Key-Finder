% helper script to count the key distribution in the dataset
clear;
Path = '/Users/apple/Downloads/classical/';
File = dir(fullfile(Path,'*.wav'));  
FileNames = {File.name}';
fileID = fopen('count2.txt','w');

Mlbs = ["Ab","A","A#","Bb","B","C","C#","Db","D","D#","Eb","E","F","F#","Gb","G","G#"];
mlbs = ["ab","a","a#","bb","b","c","c#","db","d","d#","eb","e","f","f#","gb","g","g#"];
key = [Mlbs,mlbs];
SUM = 0;
for m=1:34
    target = key(m);
    sum = 0;
    for n=1:length(FileNames)
        f = FileNames{n};

        fn = split(f, "/"); fn = fn(end);
        fn = split(fn, "."); fn = fn(end-1); 
        fn = char(fn);
        gt = split(fn, "_"); gt = gt(end);  % ground truth
        gt = char(gt);
        if gt==target
            sum=sum+1;
        end
    end
    fprintf(fileID,'%4s %4d\n',target, sum);
    SUM = SUM+sum;
end
fclose(fileID);
disp(SUM);