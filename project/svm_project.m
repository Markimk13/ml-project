%% 1. Load data
[deleted_old_variables] = init();
[~, ~, ~, featureFile, modelFile] = init_filenames();
if deleted_old_variables
    [data_train, height, width, y, data_test, options] = load_data(@svm_params);
    use_hog_visus = options.use_hog_visus;
end

%% 2. Extract/Load features.
if isfile(featureFile)
    loaded = load(featureFile);
    X = loaded.X;
    hog_visus = loaded.hog_visus;
else
    [X, hog_visus] = hog_extractFeatures(data_train, use_hog_visus);
    save(featureFile, 'X', 'hog_visus');
end

fprintf('Finished loading features.\n');

%% 3. Visualize one example.
figure;
hog_visualize(data_train, hog_visus, use_hog_visus, 1);

%% 4. Train svm model.
if isfile(modelFile)
    loaded = load(modelFile);
    model = loaded.model;
    fprintf('Finished loading model.\n');
else
    model = svm_train(X, y);
    save(modelFile, 'model');
    fprintf('Finished training model.\n');
end

%% 5. Create bounding boxes.
bounding_boxes = svm_predict(model, data_test, height, width);

fprintf('Finished creating bounding boxes.\n');

%% 6. Visualize one example.
figure;
svm_visualize(data_test, bounding_boxes, 1);