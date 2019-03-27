function [data] = get_imagesFromDataStore(dataStore, m, height, width)

    fprintf("Reading %d images from dataStore ...\n", m);
    
    data = zeros([m, height, width, 3], 'uint8');
    index = 1;
    while hasdata(dataStore)
        img = read(dataStore);
        h = size(img, 1)/height;
        w = size(img, 2)/width;
        for i = 1:h
            for j = 1:w
                ys = (i-1)*height + (1:height);
                xs = (j-1)*width + (1:width);
                data(index,:,:,:) = img(ys, xs, :);
                index = index + 1;
        
                if mod(index, 500)
                    fprintf("/tRead image %d from dataStore.\n", index);
                end
            end
        end
    end
    
    fprintf("Finished reading %d images from dataStore.\n", index-1);
    
    reset(dataStore);
end