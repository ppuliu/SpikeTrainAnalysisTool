% load mat file containing the sorted recording

function X=readSortedMatFile(file_name)

load(file_name);
neuronN = length(NST);
maxT=0;
for i=1:neuronN
    if maxT < max(NST{i})
        maxT=max(NST{i});
    end
end

bitsN = ceil(maxT*1000);   % time bin=1ms
X = zeros(neuronN,bitsN);
for i = 1:neuronN
    t=NST{i};
    for j = 1:length(t)
        X(i,ceil(t(j)*1000))=1;
    end
end