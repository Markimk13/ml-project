function [dataTrainPosFile, dataTrainNegFile, dataTestFile, featureFile, modelFile] = svm_filenames()

    folder = 'data/svm_saved/';
    if ~isfolder(folder)
        mkdir(folder);
    end
    
    dataTrainPosFile = [folder 'data_trainPos.mat'];
    dataTrainNegFile = [folder 'data_trainNeg.mat'];
    dataTestFile = [folder 'data_test.mat'];
    featureFile = [folder 'features.mat'];
    modelFile = [folder 'model.mat'];

end