function [data] = load_dataTrainNeg(backupFile, dataPath, img_height, img_width, maxResizeFactor, maxImgsPerFile, maxImages)
    
    % return the data of the backup file if exists
    if isfile(backupFile)
        loaded = load(backupFile);
        data = loaded.data;
        return;
    end
        
    % find all file paths of images
    data = imageDatastore(dataPath, 'IncludeSubfolders', true, ...
            'FileExtensions', {'.jpg', '.png'});
    imageFilenames = data.Files;

    % init the data to return
    m = min(length(imageFilenames) * maxImgsPerFile, maxImages);
    img_size = [img_height, img_width, 3];
    data = zeros([m, img_size], 'uint8');
    
    % randomly choose images
    rep_idx = repmat(1:length(imageFilenames), [1 maxImgsPerFile]);
    idx = randperm(length(rep_idx));
    imageFilenames = imageFilenames(idx(1:m));
    
    fprintf('Loading training data of %s: %d images ...\n', ...
            path, m);
    
    for i = 1:m
        % read the image
        img = imread(imageFilenames{i});
        sizeImg = size(img);
        
        % set the img from gray to rgb
        if length(size(img)) == 2
            img = cat(3, img, img, img);
        end
        
        % randomly resize the image
        if maxResizeFactor > 1
            r = rand(); % random
            q = 100; % local hyper-parameter which is higher if the resize should have less effect
            p = log(r*q+1) / log(q+1);
            resizeFactor = 1 + (maxResizeFactor-1)*(1-p);
            img = imresize(img, sizeImg(1:2)/resizeFactor);
            sizeImg = size(img);
        end
        
        % randomly crop the image
        crop_pos = sizeImg(1:2) - img_size(1:2) + 1;
        crop = floor(rand(1,2).*crop_pos + 1);
        img = img(crop(1)+(1:img_size(1)), crop(2)+(1:img_size(2)), :);
        
        % add img to data matrix
        data(i,:,:,:) = img;
        if mod(i, 100) == 0
            fprintf('... loaded %d images.\n', i);
        end
    end
    
    fprintf('Finished loading training data of %s (%d images).\n', path, m);
    
    % save the data to the backup file
    save(backupFile, 'data');
end