clear; clc; close all;
[trainPosPath, trainNegPath, ~, ~, ~, ~, ~, ~, ~, ~] = cod_params();

ObjectTrainingSize = 'Auto';
NegativeSamplesFactor = 2;
NumCascadeStages = 20;
FalseAlarmRate = 0.2;
TruePositiveRate = 0.997;
FeatureType = 'HOG';

sample_count = 5000;
table_pos_file = sprintf("Data/data_trainPos_cod3_%d.mat", sample_count);
% delete neg_file when updating trainNegPath
neg_file = "Data/data_trainNeg_cod.mat";

if isfile(table_pos_file)
    fprintf('Loading table for %d images.\n', sample_count);
    loaded = load(table_pos_file);
    table_pos = loaded.table_pos;
    fprintf('Finished loading table for %d images.\n', sample_count);
else
    pos = imageDatastore(trainPosPath, ...
            'IncludeSubfolders', true, 'FileExtensions', {'.jpg', '.png'});
    ImageFilename = pos.Files;
    image_count = length(ImageFilename);

    fprintf('Finished creating image datastore of %d images.\n', image_count);

    idx = randperm(image_count);
    idx = idx(1:min(sample_count, image_count));

    m = length(idx);
    names = cell(m, 1);
    bbs = zeros(m, 4);
    for j = 1:m
        names{j} = ImageFilename{idx(j)};
        
        found = false;
        while ~found
            try
                img = imread(names{j});
                found = true;
            catch e
                fprintf("Error for image '%s'.\n", names{j});
                disp(getReport(e));
                names{j} = ImageFilename{floor(image_count*rand()+1)};
            end
        end
        
        bbs(j,:) = get_translatedBB(get_bounding_box(img));
        if mod(j, 1000) == 0
            fprintf("Created bounding box for image %d/%d.\n", j, m);
        end
    end
    table_pos = table(names, bbs);
    save(table_pos_file, 'table_pos');
end

if isfile(neg_file)
    loaded = load(neg_file);
    neg = loaded.neg;
else
    neg = imageDatastore(trainNegPath, 'IncludeSubfolders', true, ...
            'FileExtensions', {'.jpg', '.png'});
    save(neg_file, 'neg');
end

detector_name = sprintf("cod_detector_%d.xml", sample_count);
finished = false;
round = 1;
while ~finished && round < 1000
    try   
        fprintf("Start creating detector '%s' (round %d).\n", detector_name, round);
        try
            trainCascadeObjectDetector(detector_name, 'resume');
                fprintf("Finished training from earlier session. May not have the same hyper-parameters.\n");
        catch e
            if startsWith(e.message, 'Unable to resume training from interrupted session.')
                trainCascadeObjectDetector(detector_name, ...
                        table_pos, neg, ...
                        'ObjectTrainingSize', ObjectTrainingSize, ...
                        'NegativeSamplesFactor', NegativeSamplesFactor, ...
                        'NumCascadeStages', NumCascadeStages, ...
                        'FalseAlarmRate', FalseAlarmRate, ...
                        'TruePositiveRate', TruePositiveRate, ...
                        'FeatureType', FeatureType);
            else
                rethrow(e);
            end
        end
        finished = true;
    catch e
        disp(getReport(e));
        round = round + 1;
    end
end

fprintf("Finished creating detector '%s'.\n", detector_name);     
 
      































