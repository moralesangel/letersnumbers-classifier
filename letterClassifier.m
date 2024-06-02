function letter = letterClassifier(img)

    load('lettersNet', 'net');
    
    img = imresize(img,[30 30]);

    x = extractPatterns(img);

    yprd = double(classify(net, x'))';

    letters = 'abcdefgh';

    letter = letters(yprd);

end

