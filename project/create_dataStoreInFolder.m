function [dataStore] = create_dataStoreInFolder(data, folder)

    write_imagesToFolder(data, folder);
    dataStore = imageDatastore(folder, 'FileExtensions', '.png');
    
end