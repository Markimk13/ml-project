function [data] = load_dataTrain2(path, height, width, mode, imgsPerFile, maxImages)

    % use image data store and do it randomly
    
    if ~(strcmp(mode, 'resize') || strcmp(mode, 'crop'))
        error(['Wrong mode ' mode]);
    end
    
    content = dir(path);
    names = string({content.name})';
    names = names(startsWith(names, '.') == 0);
    
    paths = strcat(path, '/', names);
    files = paths(isfile(paths) & isImageExt(paths));
    folders = paths(isfolder(paths));
    
    function [ext] = isImageExt(name)
        ext = endsWith(name, '.png') | endsWith(name, '.jpg');
    end
    

    img_size = [height, width, 3];
    m = min(load_countImageFiles(path) * imgsPerFile, maxImages);
    data = zeros([m, img_size], 'uint8');
    
    fprintf('Loading training data of %s: %d images ...\n', ...
            path, m);
    
    amount_files = floor(min(imgsPerFile*length(files), maxImages) / imgsPerFile);
    for i = 1:amount_files
        img = imread(files(i));
        for j = 1:imgsPerFile
            img2 = img;
            if strcmp(mode, 'resize')
                img2 = imresize(img, img_size(1:2));
            elseif strcmp(mode, 'crop')
                crop = floor(rand(1,2).*img_size(1:2)+1);
                img2 = img(crop(1)+(1:img_size(1)), crop(2)+(1:img_size(2)), :);
            end
            if length(size(img2)) == 3
                data(i,:,:,:) = img2;
            else
                data(i,:,:,:) = cat(3, img2, img2, img2);
            end
        end
        if mod(i, 100) == 0
            fprintf('... loaded %d images.\n', i*imgsPerFile);
        end
    end
    
    amount = imgsPerFile*amount_files;
    for i = 1:length(folders)
        newData = load_dataTrain2(folders(i), height, width, mode, imgsPerFile, maxImages-amount);
        data(amount+(1:size(newData, 1)),:,:,:) = newData;
        amount = amount + size(newData, 1);
    end
    
    fprintf('... loaded %d images in total.\n', ...
            size(data, 1));
    
end