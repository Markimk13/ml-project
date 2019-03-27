function [data_train, y] = load_dataTrain(posBackupFile, posDataPath, ...
        letter, posMode, negBackupFile, negDataPath, maxNegResizeFactor, ...
        maxNegImgsPerFile, maxNegImageFactor)

    % load data stores
    possible_letters = ['0':'9' 'A':'Z' 'a':'z'];
    letter_index = find(possible_letters == letter);
    [dataPos, dataNeg] = load_dataStore(posDataPath, negDataPath, letter_index);
    
    % load pos data
    data_trainPos = load_dataTrainPos(add_suffix(posBackupFile, ['_' char(string(letter_index))]), dataPos, posMode);
    mPos = size(data_trainPos, 1);
    height = size(data_trainPos, 2);
    width = size(data_trainPos, 3);
    
    % load neg data
    maxNegImages = floor(maxNegImageFactor*mPos);
    data_trainNeg = load_dataTrainNeg(add_suffix(negBackupFile, ['_' char(string(letter_index))]), ...
            dataNeg, height, width, maxNegResizeFactor, maxNegImgsPerFile, maxNegImages);
    mNeg = size(data_trainNeg, 1);

    % add ground truths
    data_train = zeros([mPos+mNeg height width 3], 'uint8');
    data_train(1:mPos,:,:,:) = data_trainPos;
    data_train(mPos+(1:mNeg),:,:,:) = data_trainNeg;
    y = double((1:mPos+mNeg) <= mPos)';

    function [newFile] = add_suffix(file, suffix)
        [path, name, ext] = fileparts(file);
        newFile = [path '/' name suffix ext];
    end
end