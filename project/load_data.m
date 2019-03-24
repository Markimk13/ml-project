function [data_train, height, width, y, data_test, options] = load_data(params_func)
    %% 1. Get hyper-parameters and related data
    [trainPosPath, trainNegPath, testPath, height, width, negMode, negImgsPerFile, maxPosImages, negFactor, options] ...
        = params_func();

    [dataTrainPosFile, dataTrainNegFile, dataTestFile, ~, ~] = init_filenames();
    
    %% 2. Load training data.
    data_trainPos = load_dataTrain(dataTrainPosFile, trainPosPath, height, width, 'resize', 1, maxPosImages);
    mPos = size(data_trainPos, 1);
    
    maxNegImages = floor(negFactor*min(mPos, maxPosImages));
    data_trainNeg = load_dataTrain(dataTrainNegFile, trainNegPath, height, width, negMode, negImgsPerFile, maxNegImages);
    mNeg = size(data_trainNeg, 1);

    data_train = zeros([mPos+mNeg height width 3], 'uint8');
    data_train(1:mPos,:,:,:) = data_trainPos;
    data_train(mPos+(1:mNeg),:,:,:) = data_trainNeg;
    y = double((1:mPos+mNeg) <= mPos)';

    fprintf('Finished loading training data: %d images\n', size(data_train, 1));

    %% 3. Load test data.
    if isfile(dataTestFile)
        loaded = load(dataTestFile);
        data_test = loaded.data_test;
    else
        data_test = load_dataTest(testPath);
        save(dataTestFile, 'data_test');
    end

    fprintf('Finished loading test data: %d images\n', size(data_test, 1));
end