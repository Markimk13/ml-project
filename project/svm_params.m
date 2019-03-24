function [trainPosPath, trainNegPath, testPath, height, width, negMode, negImgsPerFile, maxPosImages, negFactor, options] ...
        = svm_params()

    % TODO group parameters into options
    
    trainPosPath = 'Data/trainPos/Chars74k/Fnt/Sample002';
    trainNegPath = 'Data/trainNeg/GoogleOpenImage';
    testPath = 'Data/test/test';
    height = 24;
    width = 24;
    negMode = 'crop';
    negImgsPerFile = 100;
    maxPosImages = 10000;
    negFactor = 2;
    
    options.use_hog_visus = false;
    
end