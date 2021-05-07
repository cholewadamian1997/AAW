function outimg = binariz(img, thresh)
[sizex,sizey] = size(img);
outimg = false(sizex,sizey);
for i=1:sizex
    for j=1:sizey
        outimg(i,j)=img(i,j)>thresh;
    end
end
end

