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
backupFolder = 'data/cod_saved/';

possible_letters = ['0':'9' 'A':'Z' 'a':'z'];
letters = ['0':'9' 'A':'Z' 'a':'z'];
for i = 1:length(letters)
    fprintf("Start preparing for detector for letter %c.\n", letters(i));
    
    % decide for what letter the detector is
    letter_index = find(possible_letters == letters(i));
    pos_folder = [backupFolder 'data_trainPos_cod4_' char(string(letter_index))];
    neg_file = [backupFolder 'data_trainNeg_cod4_' char(string(letter_index)) '.mat'];

    if isfolder(pos_folder)
        pos = imageDatastore(pos_folder, 'FileExtensions', '.png');
    else
        [pos, ~] = load_dataStore(trainPosPath, trainNegPath, letter_index);
        [pos, m, height, width] = transform_dataStorePos(pos, 'locate');
        data = get_imagesFromDataStore(pos, m, height, width);
        pos = create_dataStoreInFolder(data, pos_folder);
    end
    
    % load the data stores
    if isfile(neg_file)
        loaded = load(neg_file);
        neg = loaded.neg;
    else
        [~, neg] = load_dataStore(trainPosPath, trainNegPath, letter_index);
        save(neg_file, 'neg');
    end
    
    % load the bounding boxes
    imageFilenames = pos.Files;
    letter_bbs = zeros(length(imageFilenames), 4);
    for j = 1:length(imageFilenames)
        img = read(pos);
        letter_bbs(j,:) = get_translatedBB(get_bounding_box(img));
    end
    
    table_pos = table(imageFilenames, letter_bbs);
    
    detector_name = sprintf("cod_detector_letter%d_%c.xml", letter_index, letters(i));
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
    
    copyfile(detector_name, [backupFolder char(detector_name)]);
    fprintf("Finished creating detector '%s'.\n", detector_name); 
end
