function [trainPosPath, trainNegPath] = cod_params()

    % delete pos backup file when updating trainPosPath
    trainPosPath = 'data/pos/Chars74k/Fnt';
    % delete neg backup file when updating trainNegPath
    trainNegPath = 'data/neg/Selected';
    
end