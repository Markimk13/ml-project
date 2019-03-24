detectorPath = 'cod_detector_letter49_1.xml';
%1.
%imgPath = 'Data/trainPos/Chars74k/Fnt/Sample002/img002-00001.png';
%2.
%imgPath = 'Data/test/Selected/test.png';
%3.
imgPath = 'Data/test/Selected/00cb389da529ba46.jpg';
%4.
%imgPath = 'Data/trainPos/mnt/ramdisk/max/90kDICT32px/2390/3/1_Completely_15463.jpg';
[img, bb] = cod_predict(detectorPath, imgPath);

figure;
imshow(img);
disp("bounding boxes:");
disp(bb);