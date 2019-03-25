clear; clc; close all;
[trainPosPath, trainNegPath, testPath, height, width, ~, ~, ~, ~, ~] ...
        = cod_params();
    
pos = imageDatastore(trainPosPath, 'IncludeSubfolders', true, 'FileExtensions', {'.jpg', '.png'});
ImageFilename = pos.Files;
idx = randperm(length(ImageFilename));
ImageFilename = ImageFilename(idx(1:5000));

letter = zeros(length(ImageFilename), 4);
for i = 1:length(ImageFilename)
    img = imread(ImageFilename{i});
    letter(i,:) = get_bounding_box(img);
end
table_pos = table(ImageFilename, letter);

ObjectTrainingSize = [16 16; 24 24];
NegativeSamplesFactor = [1; 2];
NumCascadeStages = [5; 7];
FalseAlarmRate = [0.3; 0.5; 0.7];
TruePositiveRate = [0.9; 0.95];
FeatureType = ['HOG'; 'LBP'];

max_idx = [size(ObjectTrainingSize, 1) + 1; size(NegativeSamplesFactor, 1); ...
        size(NumCascadeStages, 1); size(FalseAlarmRate, 1); ...
        size(TruePositiveRate, 1); size(FeatureType, 1)];
idx = ones(size(max_idx));

finished = false;
while ~finished
    if idx(1) ~= max_idx(1)
        ots = ObjectTrainingSize(idx(1),:);
        ots_str = [num2str(ots(1)) 'x' num2str(ots(2))];
    else
        ots = 'Auto';
        ots_str = ots;
    end
    nsf = NegativeSamplesFactor(idx(2));
    ncs = NumCascadeStages(idx(3));
    far = FalseAlarmRate(idx(4));
    tpr = TruePositiveRate(idx(5));
    ft = FeatureType(idx(6), :);
    
    trainCascadeObjectDetector(['cod_detector_' ots_str '_' num2str(nsf) ...
            '_' num2str(ncs) '_' num2str(far) '_' num2str(tpr) '_' ft '.xml'], ...
            table_pos, trainNegPath, ...
            'ObjectTrainingSize', ots, ...
            'NegativeSamplesFactor', nsf, ...
            'NumCascadeStages', ncs, ...
            'FalseAlarmRate', far, ...
            'TruePositiveRate', tpr, ...
            'FeatureType', ft);
    
    i = size(idx, 1);
    while i >= 1 && idx(i) == max_idx(i)
        idx(i) = 1;
        i = i - 1;
    end
    if i >= 0
        idx(i) = idx(i) + 1;
    else
        finished = true;
    end
end