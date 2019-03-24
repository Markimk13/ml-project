function [data] = load_dataTrain(filePath, dataPath, height, width, mode, imgsPerFile, maxImages)

    % Check if the best height and width need to be found
    % to create HOG features.
    set_sizes = height == -1 && width == -1;

    data = imageDatastore(dataPath, 'IncludeSubfolders', true, ...
            'FileExtensions', {'.jpg', '.png'});
    imageFilenames = data.Files;

    count = length(imageFilenames);
    sizes = cell(count, 2);

    for i = 1:count
        img = imread(imageFilenames{i});
        letter_bb = get_bounding_box(img);
        sizes(i, :) = [letter_bb(4), letter_bb(3)];
    end

    if height == -1 && width == -1
    end

    file_exists = isfile(filePath);
    if file_exists 
        loaded = load(filePath);
        correct_size = height == loaded.height && width == loaded.width;
    end

    if file_exists && correct_size
        loaded = load(filePath);
        data = loaded.data;
    else
        data = load_dataTrain2(filenames, bounding_boxes, height, width, mode, imgsPerFile, maxImages);
        save(filePath, 'data', 'height', 'width');
    end

end