function [dataTrainPosFile, dataTrainNegFile, dataTestFile, featureFile, modelFile] = init_filenames()

    dataTrainPosFile = strcat('Data/data_trainPos.mat');
    dataTrainNegFile = strcat('Data/data_trainNeg.mat');
    dataTestFile = strcat('Data/data_test.mat');
    featureFile = strcat('Data/features.mat');
    modelFile = strcat('Data/model.mat');

end