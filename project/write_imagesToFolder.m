function write_imagesToFolder(data, folder)
    
    size_data = size(data);
    fprintf("Writing %d images to folder ...\n", size_data(1));
    
    if isfolder(folder)
        error("Folder already exists");
    end

    mkdir(folder);
    
    digitCount = floor(log10(size_data(1))) + 1;
    format = sprintf("%%s/img-%%0%dd.png", digitCount);
    for i = 1:size_data(1)
        img = reshape(data(i,:,:,:), size_data(2:4));
        imwrite(img, sprintf(format, folder, i));
        
        if mod(i, 500)
            fprintf("/tWrote image %d to folder.\n", i);
        end
    end
    
    fprintf("Finished writing %d images to folder.\n", size_data(1));
    
end