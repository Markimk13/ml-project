function [features, hog_visus] = hog_extractFeatures(data, use_hog_visus)

    size_data = size(data);
    m = size_data(1);
    hog_visus = cell(m, 1);
    
    fprintf('Started extracting %d features.\n', m);
    
    for i=1:m
        img = reshape(data(i,:,:,:), size_data(2:4));
        [feature, hog_visu] = extractHOGFeatures(img);
        
        if i == 1
            features = zeros([m, size(feature, 2)], 'single');
        end
        
        features(i,:) = feature;
        if use_hog_visus
            hog_visus{i} = hog_visu;
        end
        
        if mod(i, 500) == 0
            fprintf('Extracted features of image %d / %d.\n', i, m);
        end
    end

end