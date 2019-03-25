function [data_train, y, data_test, options] = load_data(params_func)
    %% 1. Get hyper-parameters and related data
    [trainPosPath, trainNegPath, testPath, ~, ~, negMode, negImgsPerFile, ~, negFactor, options] ...
        = params_func();

    [dataTrainPosFile, dataTrainNegFile, dataTestFile, ~, ~] = init_filenames();
    
    %% 2. Load training data.
    [data_train, y] = load_dataTrain(dataTrainPosFile, trainPosPath, 'crop', ...
            dataTrainNegFile, trainNegPath, negMode, negImgsPerFile, negFactor);

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