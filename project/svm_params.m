function [trainPosPath, trainNegPath, testPath, letter, posMode, posRescaleFactor, ...
        maxNegResizeFactor, negImgsPerFile, negFactor, options] ...
    = svm_params()

    trainPosPath = 'data/pos/Chars74k/Fnt';
    trainNegPath = 'data/neg/Selected';
    testPath = 'data/test/test';
    posMode = 'crop';
    posRescaleFactor = 4;
    
    letter = '0';
    
    maxNegResizeFactor = 5;
    negImgsPerFile = 100;
    negFactor = 5;
    
    options.use_hog_visus = false;
    
end