%1.
%imgPath = 'data/pos/Chars74k/Fnt/Sample001/img001-00001.png';
%2.
imgPath = 'data/test/Selected/test.png';
%3.
%imgPath = 'data/test/Selected/000d3e755ce7542c.jpg';

%detectorPath = 'data/cod_saved/cod_detector_letter4_3.xml';
%[img, bb] = cod_predict(detectorPath, imgPath);

folderPath = 'data/cod_saved';
[img, bb] = cod_predictAll(folderPath, imgPath);

figure;
imshow(img);
disp("bounding boxes:");
disp(bb);