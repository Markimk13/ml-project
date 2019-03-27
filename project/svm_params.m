function [trainPosPath, trainNegPath, testPath, height, width, maxNegResizeFactor, negImgsPerFile, maxPosImages, negFactor, options] ...
        = svm_params()

    % TODO group parameters into options
    
    trainPosPath = 'data/pos/Chars74k/Fnt';
    trainNegPath = 'data/neg/Selected';
    testPath = 'data/test/test';
    height = 24;
    width = 24;
    maxNegResizeFactor = 5;
    negImgsPerFile = 100;
    maxPosImages = 10000;
    negFactor = 2;
    
    options.use_hog_visus = false;
    
end