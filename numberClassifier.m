function number = numberClassifier(img)

    load('numbersNet', 'net');
    
    img = imresize(img,[30 30]);

    x = extractPatterns(img);

    yprd = double(classify(net, x'))';

    numbers = '12345678';

    number = numbers(yprd);

end

