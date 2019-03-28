function [img_bb, bb_cell] = cod_predictAll(folderPath, imgPath)

    content = dir(folderPath);
    names = string({content.name})';
    names = names(startsWith(names, 'cod_detector_letter') ...
            & endsWith(names, '.xml'));
        
    img = imread(imgPath);
    img_bb = img;
    
    m = length(names);
    bb_cell = cell(m, 2);
    for i = 1:m
        name = char(names(i));
        letter = name(find(name == '_', 1, 'last')+1:find(name == '.', 1, 'last')-1);
        detector = vision.CascadeObjectDetector(sprintf("%s/%s", ...
                folderPath, name));
        bb = detector(img);
        img_bb = insertObjectAnnotation(img_bb, 'rectangle', bb, letter);
        bb_cell{i,1} = letter;
        bb_cell{i,2} = bb;
    end
end