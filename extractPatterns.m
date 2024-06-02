function x = extractPatterns(img)

    w = size(img,2);
    h = size(img,1);

    %% Sections
    sections = [1,  1,  floor(w/3),floor(h/2);
                1,floor(h/2),  floor(w/3),floor(h/2);

                floor(w/3),  1,  floor(w/3),floor(h/3);
                floor(w/3),floor(h/3),  floor(w/3),floor(h/3);
                floor(w/3),floor(h*2/3),floor(w/3),floor(h/3);

                floor(w*2/3),  1,floor(w/3),floor(h/2);
                floor(w*2/3),floor(h/2),floor(w/3),floor(h/2)];

    %% Pattern
    x = zeros(7,1);
    for i=1:7
        imgCropped = imcrop(img,sections(i, :));
        totalSize = size(imgCropped, 1) * size(imgCropped, 2);
        x(i) = nnz(imgCropped == 0) / totalSize;
    end

end

