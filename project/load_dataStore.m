function [dataPos, dataNeg] = load_dataStore(posDataPath, negDataPath, letter_index)

    % get subfolders
    content = dir(posDataPath);
    dirs = string({content.name})';
    dirs = dirs(startsWith(dirs, '.') == 0);
    
    % init image data stores
    dataPos = imageDatastore([posDataPath '/' sprintf('Sample%03d', letter_index)], ...
            'IncludeSubfolders', true, ...
            'FileExtensions', {'.jpg', '.png'});
        
    negPaths = cell(length(dirs), 1);
    for i = 1:length(dirs)
        if ~strcmp(sprintf('Sample%03d', letter_index), dirs(i))
            negPaths{i} = [posDataPath '/' char(dirs(i))];
        else
            negPaths{i} = negDataPath;
        end
    end
    dataNeg = imageDatastore(negPaths, ...
            'IncludeSubfolders', true, ...
            'FileExtensions', {'.jpg', '.png'});

end