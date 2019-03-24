function [img_bb, bb] = cod_predict(detectorPath, imgPath)

    detector = vision.CascadeObjectDetector(detectorPath);
    img = imread(imgPath);
    bb = detector(img);
    img_bb = insertObjectAnnotation(img, 'rectangle', bb, 'Letter');

end