function [dataTrainPosFile, dataTrainNegFile, dataTestFile, featureFile, modelFile] = svm_filenames(letter)

    folder = 'data/svm_saved/';
    if ~isfolder(folder)
        mkdir(folder);
    end
    
    possible_letters = ['0':'9' 'A':'Z' 'a':'z'];
    letter_index = find(possible_letters == letter);
    
    dataTrainPosFile = [folder 'data_trainPos_' char(string(letter_index)) '.mat'];
    dataTrainNegFile = [folder 'data_trainNeg_' char(string(letter_index)) '.mat'];
    dataTestFile = [folder 'data_test.mat'];
    featureFile = [folder 'features.mat'];
    modelFile = [folder 'model.mat'];

end