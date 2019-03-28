clear; clc; close all;
[trainPosPath, trainNegPath] = cod_params();

ObjectTrainingSize = 'Auto';
NegativeSamplesFactor = 2;
NumCascadeStages = 10;
FalseAlarmRate = 0.5;
TruePositiveRate = 0.995;
FeatureType = 'HOG';


pos_file = "data/data_trainPos_cod2.mat";
% delete neg_file when updating trainNegPath
neg_file = "data/data_trainNeg_cod2.mat";

if isfile(pos_file)
    loaded = load(pos_file);
    pos = loaded.pos;
else
    pos = imageDatastore(trainPosPath, 'IncludeSubfolders', true, ...
            'FileExtensions', {'.jpg', '.png'});
    save(pos_file, 'pos');
end

if isfile(neg_file)
    loaded = load(neg_file);
    neg = loaded.neg;
else
    neg = imageDatastore(trainNegPath, 'IncludeSubfolders', true, ...
            'FileExtensions', {'.jpg', '.png'});
    save(neg_file, 'neg');
end


ImageFilename = pos.Files;
possible_letters = ['0':'9' 'A':'Z' 'a':'z'];
letters = ['1'];
for i = 1:length(letters)
    found_letter = zeros(length(ImageFilename), 1);
    for j = 1:length(ImageFilename)
        if contains(ImageFilename{j}, sprintf("img%03d", find(possible_letters == letters(i))))
            found_letter(j) = 1;
        end
    end
    count = sum(found_letter);
    filenames = cell(count, 1);
    letter = zeros(count, 4);
    
    index = 1;
    for j = 1:length(ImageFilename)
        if found_letter(j) == 1
            filenames{index} = ImageFilename{j};
            img = imread(ImageFilename{j});
            letter(index,:) = get_translatedBB(get_bounding_box(img));
            index = index + 1;
        end
    end
    
    table_pos = table(filenames, letter);
    
    detector_name = sprintf("cod_detector_letter%d_%c.xml", letters(i), letters(i));
    finished = false;
    round = 1;
    while ~finished && round < 3
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
end
