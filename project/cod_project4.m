clear; clc; close all;

% set hyper-parameters
ObjectTrainingSize = 'Auto';
NegativeSamplesFactor = 2;
NumCascadeStages = 10;
FalseAlarmRate = 0.5;
TruePositiveRate = 0.995;
FeatureType = 'HOG';

% delete backups of cod4 when updating file paths
trainPosPath = 'data/pos/Chars74k/Fnt';
trainNegPath = 'data/neg/Selected';

possible_letters = ['0':'9' 'A':'Z' 'a':'z'];
letters = ['0'];
for i = 1:length(letters)
    % decide for what letter the detector is
    letter_index = find(possible_letters == letters(i));
    pos_file = ['data/cod_saved/data_trainPos_cod4_' char(string(letter_index)) '.mat'];
    neg_file = ['data/cod_saved/data_trainNeg_cod4_' char(string(letter_index)) '.mat'];

    % load the data stores
    if isfile(pos_file) && isfile(neg_file)
        loaded = load(pos_file);
        pos = loaded.pos;
        loaded = load(neg_file);
        neg = loaded.neg;
    else
        [pos, neg] = load_dataStore(trainPosPath, trainNegPath, letter_index);
        pos = transform_dataStorePos(pos, 'crop');

        save(pos_file, 'pos');
        save(neg_file, 'neg');
    end
    
    % load the bounding boxes
    imageFilenames = pos.UnderlyingDatastore.Files;
    letter_bbs = zeros(length(imageFilenames), 4);
    for j = 1:length(imageFilenames)
        img = read(pos);
        letter_bbs(j,:) = get_translatedBB(get_bounding_box(img));
    end
    
    table_pos = table(imageFilenames, letter_bbs);
    
    detector_name = sprintf("cod_detector_letter%d_%c.xml", letter_index, letters(i));
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
end
