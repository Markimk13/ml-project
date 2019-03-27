function [data] = load_dataTrainNeg(backupFile, dataStore, img_height, img_width, maxResizeFactor, maxImgsPerFile, maxImages)
    
    % return the data of the backup file if exists
    if isfile(backupFile)
        fprintf('Loading neg data from backup ...\n');
        loaded = load(backupFile);
        data = loaded.data;
        fprintf('Finished loading neg data from backup.\n');
        return;
    end
    
    % get all file paths of images
    imageFilenames = dataStore.Files;

    % init the data to return
    m = min(length(imageFilenames) * maxImgsPerFile, maxImages);
    img_size = [img_height, img_width, 3];
    data = zeros([m, img_size], 'uint8');
    
    % randomly choose images
    rep_idx = repmat(1:length(imageFilenames), [1 maxImgsPerFile]);
    idx = randperm(length(rep_idx));
    idx = rep_idx(idx(1:m));
    imageFilenames = imageFilenames(idx);
    
    fprintf('Loading neg data (%d images) ...\n', m);
    
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
        crop_pos = sizeImg(1:2) - img_size(1:2);
        sizeImg = min(sizeImg, img_size);
        crop = floor(rand(1,2).*max(crop_pos, 0));
        img = img(crop(1)+(1:sizeImg(1)), crop(2)+(1:sizeImg(2)), :);
        
        % set it to the center if too small
        topLeft = floor(max(-crop_pos, 0) / 2);
        img2 = 255 * ones(img_size, 'uint8');
        img2(topLeft(1)+(1:sizeImg(1)),topLeft(2)+(1:sizeImg(2)),:) = img;
        img = img2;
        
        % add img to data matrix
        data(i,:,:,:) = img;
        if mod(i, 100) == 0
            fprintf('... loaded %d images.\n', i);
        end
    end
    
    fprintf('Finished loading neg data (%d images).\n', m);
    
    % save the data to the backup file
    save(backupFile, 'data');
end