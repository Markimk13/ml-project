function [data] = load_dataTrainPos(backupFile, dataStore, mode, rescaleFactor)
    
    % improvements: add noise/negative examples to the background of the image
    
    % return the data of the backup file if exists
    if isfile(backupFile)
        fprintf('Loading pos data from backup ...\n');
        loaded = load(backupFile);
        data = loaded.data;
        fprintf('Finished loading pos data from backup.\n');
        return;
    end
    
    % transform the dataStore
    [transformed, m, height, width] = transform_dataStorePos(dataStore, mode, rescaleFactor);
    fprintf('Loading pos data (%d images) ...\n', m);
    
    % read the data
    data = get_imagesFromDataStore(transformed, m, height, width);
    
    fprintf('Finished loading pos data (%d images).\n', m);
    
    % save the data to the backup file
    save(backupFile, 'data');
end