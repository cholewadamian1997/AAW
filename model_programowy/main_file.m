clear all;
% model programowy
monke = imread('mandril.jpg');
monke = rgb2gray(monke);

% własna implementacja
histogram_self = im2histo(monke);
otsu = hist2otsu(histogram_self);
binar_self = binariz(monke,otsu);

% implementacja matlab
[histogram_preimplement, bin] = imhist(monke);
otsuT = otsuthresh(histogram_preimplement);
binar_preimplement = im2bw(monke,otsuT);

figure(1)
subplot(2,2,1)
imshow(binar_preimplement)
title('Obraz matlab')
subplot(2,2,2)
imshow(binar_self)
title('Obraz model programowy')
subplot(2,2,3)
diff = imabsdiff(binar_preimplement,binar_self);
imshow(diff,[])
title(strcat('Różnica, suma elementów:', num2str(sum(diff,'all'))))