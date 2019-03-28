function [trainPosPath, trainNegPath, testPath, posMode, maxNegResizeFactor, negImgsPerFile, negFactor, options] ...
        = svm_params()

    trainPosPath = 'data/pos/Chars74k/Fnt';
    trainNegPath = 'data/neg/Selected';
    testPath = 'data/test/test';
    posMode = 'crop';
    maxNegResizeFactor = 5;
    negImgsPerFile = 100;
    negFactor = 2;
    
    options.use_hog_visus = false;
    
end