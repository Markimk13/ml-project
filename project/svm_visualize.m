function [] = svm_visualize(data, bounding_boxes, i)

    img = data{i};
    bb = bounding_boxes{i};
    
    for i = 1:size(bb, 1)
        img = insertObjectAnnotation(img, 'rectangle', bb(i,:), 'letter');
    end
    
    imshow(img);
    
end