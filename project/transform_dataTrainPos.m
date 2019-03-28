function [img] = transform_dataTrainPos(oldImg, height, width, mode, resizeFactor)

    % resize the image to a useful size
    img = oldImg;
    img = imresize(img, [size(img,1), size(img,2)]/resizeFactor);
    
    % check if the image has the correct size
    if strcmp(mode, 'plain') || strcmp(mode, 'locate')
        if height ~= size(img, 1) || width ~= size(img, 2)
            error("Image does not have the correct size.");
        end
    end
    
    % set the img from gray to rgb
    if length(size(img)) == 2
        img = cat(3, img, img, img);
    end
    
    % nothing to do in this mode
    if strcmp(mode, 'plain')
        return;
    end
    
    % init the size for the image to return
    img_size = [height, width, 3];
    
    % reduce img to the bounding box
    bb = get_bounding_box(img);
    img = img(bb(1)+(1:bb(3)),bb(2)+(1:bb(4)),:);

    if strcmp(mode, 'crop') || strcmp(mode, 'resize')
        % resize if the mode is 'resize' or the bb does not fit in the img_size
        if strcmp(mode, 'resize')
            img_height = min(height, bb(3)*width/bb(4));
            img_width = min(width, bb(4)*height/bb(3));
            img = imresize(img, [img_height, img_width]);
        end

        % center img to the img_size
        img_top = floor((height-size(img, 1)) / 2);
        img_left = floor((width-size(img, 2)) / 2);
        img2 = 255 * ones(img_size, 'uint8');
        img2(img_top+(1:size(img, 1)),img_left+(1:size(img, 2)),:) = img;
        img = img2;

    elseif strcmp(mode, 'locate')
        % place img randomly in the area of img_size
        maxTopLeft = img_size(1:2) - bb(3:4) + 1;
        topLeft = floor(rand(1,2).*maxTopLeft);
        img2 = 255 * ones(img_size, 'uint8');
        img2(topLeft(1)+(1:bb(3)),topLeft(2)+(1:bb(4)),:) = img;
        img = img2;
    end

end