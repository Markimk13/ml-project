function [data] = load_dataTest(path)

    content = dir(path);
    names = string({content.name})';
    names = names(startsWith(names, '.') == 0);
    
    paths = strcat(path, '/', names);
    files = paths(isfile(paths) & isImageExt(paths));
    folders = paths(isfolder(paths));
    
    function [ext] = isImageExt(name)
        ext = endsWith(name, '.png') | endsWith(name, '.jpg');
    end
    

    m = load_countImageFiles(path);
    data = cell(m, 1);
    
    fprintf('Loading test data of %s: %d images ...\n', ...
            path, m);
    
    for i = 1:length(files)
        img = imread(files(i));
        if size(size(img), 2) == 3
            data{i} = img;
        end
        if mod(i, 500) == 0
            fprintf('... loaded %d images.\n', i);
        end
    end
    
    amount = length(files);
    for i = 1:length(folders)
        newData = load_dataTest(folders(i));
        data((1:m)>=amount+1 & (1:m)<=amount+size(newData, 1)) = newData;
        amount = amount + size(newData, 1);
    end
    
    fprintf('... loaded %d images in total.\n', ...
            size(data, 1));
    
end