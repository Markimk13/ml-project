function [trainPosPath, trainNegPath, testPath, height, width, negMode, negImgsPerFile, maxPosImages, negFactor, options] ...
        = cod_params()

    % TODO group parameters into options
    
    trainPosPath = 'data/pos/mnt/ramdisk/max/90kDICT32px';
    % delete neg_file when updating trainNegPath
    trainNegPath = 'data/neg/test_challenge/challenge2018';
    testPath = 'data/test';
    height = 100;
    width = 100;
    
    % not used
    negMode = '';
    negImgsPerFile = 1;
    maxPosImages = 10000;
    negFactor = 2;
    
    options = [];
    
end