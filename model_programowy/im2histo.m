function hist = im2histo(img)
[sizex,sizey] = size(img);
hist = zeros(256,1);
for i=1:sizex
    for j=1:sizey
        hist(img(i,j))=hist(img(i,j))+1;
    end
end
end

