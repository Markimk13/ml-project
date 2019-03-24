function [data] = load_dataTrainPos(backupFile, dataPath, mode)
    
    % improvements: add noise/negative examples to the background of the image

    % check for supported mode
    if ~(strcmp(mode, 'resize') || strcmp(mode, 'crop'))
        error(['Wrong mode ' mode]);
    end
    
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

    % find height and width of all bounding boxes
    m = length(imageFilenames);
    sizes = cell(m, 2);
    for i = 1:m
        img = imread(imageFilenames{i});
        bb = get_bounding_box(img);
        sizes(i, :) = bb(3:4);
    end

    % find the most useful height and width for extracting HOG features
    size_avg = sum(sizes) / m;
    height = size_avg(1);
    width = size_avg(2);
    img_size = [size_avg, 3];
    data = zeros([m, img_size], 'uint8');
    
    fprintf('Loading training data of %s (%d images) ...\n', path, m);
    
    for i = 1:m
        % read the image and get its bounding box
        img = imread(imageFilenames{i});
        bb = get_bounding_box(img);
        
        % set the img from gray to rgb
        if length(size(img)) == 2
            data(i,:,:,:) = cat(3, img, img, img);
        end
        
        if strcmp(mode, 'crop') || strcmp(mode, 'resize')
            % reduce img to the bounding box
            img = img(bb(1)+(1:bb(3)),bb(2)+(1:bb(4)),:);
            
            % resize if the mode is 'resize' or the bb does not fit in the img_size
            if strcmp(mode, 'resize') || bb(3) > height && bb(4) > width
                img_height = min(height, bb(3)*width/bb(4));
                img_width = min(width, bb(4)*height/bb(3));
                img = imresize(img, [img_height, img_width]);
            end
            
            % center img to the img_size
            img_top = floor(height-size(img, 1) / 2);
            img_left = floor(height-size(img, 2) / 2);
            img2 = zeros(img_size, 'uint8');
            img2(img_top+(1:size(img, 1)),img_left+(1:size(img, 2)),:) = img;
            img = img2;
        end
        
        % add img to data matrix
        data(i,:,:,:) = img;
        if mod(i, 100) == 0
            fprintf('\t... loaded %d images.\n', i);
        end
    end
    
    fprintf('Finished loading training data of %s (%d images).\n', path, m);
    
    % save the data to the backup file
    save(backupFile, 'data', 'height', 'width');
end