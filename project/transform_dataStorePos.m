function [transformed, m, height, width] = transform_dataStorePos(dataStore, mode)

    % check for supported mode
    if ~(strcmp(mode, 'resize') || strcmp(mode, 'crop') ...
            || strcmp(mode, 'plain') || strcmp(mode, 'locate'))
        error(['Wrong mode ' mode]);
    end
    
    imageFilenames = dataStore.Files;
    m = length(imageFilenames);
    
    mPerImg = 1;
    resizeFactor = 1;
    if strcmp(mode, 'crop') || strcmp(mode, 'resize')
        resizeFactor = 4;
        
        % find height and width of all bounding boxes
        sizes = zeros(m, 2);
        for i = 1:m
            img = imread(imageFilenames{i});
            bb = get_bounding_box(img);
            sizes(i, :) = bb(3:4);
        end

        % find the most useful height and width for extracting HOG features
        size_max = ceil(max(sizes)/resizeFactor);
        height = size_max(1);
        width = size_max(2);
        
    elseif strcmp(mode, 'locate')
        mPerImg = 10;
        
        img = imread(imageFilenames{1});
        height = ceil(size(img, 1)/resizeFactor);
        width = ceil(size(img, 2)/resizeFactor);
        
    elseif strcmp(mode, 'plain')
        img = imread(imageFilenames{1});
        height = ceil(size(img, 1)/resizeFactor);
        width = ceil(size(img, 2)/resizeFactor);
    end
    
    fprintf('Transforming pos data (%d images à %d rounds) ...\n', m, mPerImg);

    % use the settings to create a dataStore with mPerImg variations of an
    % image
    transformed = transform(dataStore, @(img) transform_dataTrainPos(img, ...
            height, width, mode, resizeFactor));
    fprintf('\tFinished round 1.\n');
    for i = 2:mPerImg
        transformed = combine(transformed, ...
                transform(dataStore, @(img) transform_dataTrainPos(img, ...
                        height, width, mode, resizeFactor)));
        fprintf('\tFinished round %d.\n', i);
    end
    
    fprintf('Finished transforming pos data (%d images).\n', mPerImg*m);
    
    m = mPerImg*m;
end