detectorPath = 'data/cod_saved/1_001/cod_detector_letter1_0.xml';
%1.
%imgPath = 'data/pos/Chars74k/Fnt/Sample001/img001-00001.png';
%2.
imgPath = 'data/test/Selected/test.png';
%3.
%imgPath = 'data/test/Selected/00cb389da529ba46.jpg';

[img, bb] = cod_predict(detectorPath, imgPath);

figure;
imshow(img);
disp("bounding boxes:");
disp(bb);