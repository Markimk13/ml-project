function [amount] = load_countImageFiles(path)

    content = dir(path);
    names = string({content.name})';
    names = names(startsWith(names, '.') == 0);
    
    paths = strcat(path, '/', names);
    files = paths(isfile(paths) & isImageExt(paths));
    folders = paths(isfolder(paths));
    
    function [ext] = isImageExt(name)
        ext = endsWith(name, '.png') | endsWith(name, '.jpg');
    end
    

    amount = length(files);
    
    for i = 1:length(folders)
        amount = amount + load_countImageFiles(folders(i));
    end
    
end