function [] = hog_visualize(data, hog_visus, use_hog_visus, i)

    size_data = size(data);
    imshow(reshape(data(i,:,:,:), size_data(2:4)));
    
    if use_hog_visus
        hold on;
        plot(hog_visus{i});
        hold off;
    end

end