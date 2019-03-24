function [bb] = get_bounding_box(img)

    % finds the bounding box for a letter with a white background
    % TODO use image segmentation to extend it on any background

    neg_img = 255 - img;
    if length(size(neg_img)) == 3
        sum_img = sum(neg_img, 3);
    else
        sum_img = neg_img;
    end
    
    find_imgY = find(sum(sum_img, 2) ~= 0);
    find_imgX = find(sum(sum_img, 1) ~= 0);
    
    top = min(find_imgY);
    left = min(find_imgX);
    bottom = max(find_imgY);
    right = max(find_imgX);
    bb = [top, left, bottom-top, right-left];

end