function [data] = load_dataTest(path)

    dataStore = imageDatastore(path, ...
            'IncludeSubfolders', true, ...
            'FileExtensions', {'.jpg', '.png'});
    imageFilenames = dataStore.Files;

    m = length(imageFilenames);
    data = cell(m, 1);
    
    fprintf('Loading test data of %s: %d images ...\n', ...
            path, m);
    
    for i = 1:m
        img = read(dataStore);
        if length(size(img)) == 2
            img = cat(3, img, img, img);
        end
        
        data{i} = img;
        
        if mod(i, 500) == 0
            fprintf('... loaded %d images.\n', i);
        end
    end
    
    fprintf('... loaded %d images in total.\n', m);
    
end