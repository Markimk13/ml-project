function [data_train, y] = load_dataTrain(posBackupFile, posDataPath, posMode, ...
        negBackupFile, negDataPath, maxNegResizeFactor, ...
        maxNegImgsPerFile, maxNegImageFactor)

    data_trainPos = load_dataTrainPos(posBackupFile, posDataPath, posMode);
    mPos = size(data_trainPos, 1);
    height = size(data_trainPos, 2);
    width = size(data_trainPos, 3);
    
    maxNegImages = floor(maxNegImageFactor*mPos);
    data_trainNeg = load_dataTrainNeg(negBackupFile, negDataPath, maxNegResizeFactor, ...
            height, width, maxNegImgsPerFile, maxNegImages);
    mNeg = size(data_trainNeg, 1);

    data_train = zeros([mPos+mNeg height width 3], 'uint8');
    data_train(1:mPos,:,:,:) = data_trainPos;
    data_train(mPos+(1:mNeg),:,:,:) = data_trainNeg;
    y = double((1:mPos+mNeg) <= mPos)';

end