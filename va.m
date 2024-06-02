function move = va()

    cam = webcam(1);

    move = '0000';

    % Time needed to detected a character
    framesWaiting = 25;
    
    figure;
    % Loop through every character in the move
    for c=1:4
        
        lastPrediction = '';
        detectedTimes = 0;
        while detectedTimes < framesWaiting
            % Current frame
            img = snapshot(cam);
    
            % Show original image
            imshow(img);hold on;
    
            % Preprocessing
            imgGray = rgb2gray(img);
            imgBW = imbinarize(imgGray);
            
            ele = strel('square',4);
            imgBW = imerode(imgBW, ele);
            
            ele = strel('square',4);
            imgBW = imdilate(imgBW,ele);
    
    
            % Detecting letter/number
            imgLabel = logical(not(imgBW));
            props = regionprops(imgLabel, 'Area', 'BoundingBox','Orientation');
    
            infT = size(img,1)*size(img,2) * 0.002;
            supT = size(img,1)*size(img,2) * 0.05;
            position = [1, 1];
            center = [size(img,2)/2, size(img,1)/2];
            index = 0;
            
            for i = 1:numel(props)
    
                if infT < props(i).Area && props(i).Area < supT
                        
                    w = props(i).BoundingBox(3);
                    h = props(i).BoundingBox(4);
                    x = props(i).BoundingBox(1) + w/2;
                    y = props(i).BoundingBox(2) + h/2;
                    d1 = pdist([x, y; center]);
                    d2 = pdist([position;center]);
            
                    if d1 < d2 && d1 < size(img,2)*0.3
                        position = [x, y];
                        index = i;
                        color = 1 - d1/pdist([1,1;center]);
                    end
                    
                end
                
            end
    
    
            % If letter/number detected
            if index > 0
    
                % Cropped letter/number
                imgCroppedBW = imcrop(imgBW, props(index).BoundingBox);
    
                % Add rotation
    %             orientation = props(index).Orientation;
    %             if orientation >=0
    %                 imgRotated = imrotate(imgCropped, abs(90-orientation));
    %                 rotated = abs(90-orientation);
    %             else
    %                 imgRotated = imrotate(imgCropped, -(90+orientation));
    %                 rotated = -(90+orientation);
    %             end
    %             
    % 
    %           imgCroppedBW = imgRotated;
    
                %% Create dataset to train neural nets
                %storeLetterImg(imgCroppedBW, id, 'a');
                %storeNumberImg(imgCroppedBW, id, '1');
                
    
                % Clasiffier
                if mod(c, 2) == 1
                    prediction = letterClassifier(imgCroppedBW);
                    text = ['Letter: ' prediction];
                else
                    prediction = numberClassifier(imgCroppedBW);
                    text = ['Number: ' prediction];
                end
    
                % Show prediction
                imgWithText = insertText(img, [0,60], text);
                imshow(imgWithText);
                
                % Show computer vision
                imshow(imresize(imgCroppedBW, [60 60]));
    
                % Show perimeter rectangle
                rectangle('Position', props(index).BoundingBox, ...
                'Linewidth', 3, 'EdgeColor', [1-color, color, 0], 'LineStyle', '-');
                
                % Show filled rectangle
                bbox = props(index).BoundingBox;
                x = bbox(1);
                y = bbox(2);
                width = bbox(3);
                height = bbox(4);
                xCoords = [x, x+width, x+width, x];
                yCoords = [y, y, y+height, y+height];
                patch(xCoords, yCoords, [1-detectedTimes/framesWaiting, detectedTimes/framesWaiting, 0], 'FaceAlpha', 0.5, 'EdgeColor', 'none');

                % Check if character is fully detected
                if detectedTimes < 1
                    lastPrediction = prediction;
                    detectedTimes = detectedTimes + 1;
                else
                    if lastPrediction == prediction
                        detectedTimes = detectedTimes + 1;
                    else
                        detectedTimes = 0;
                        lastPrediction = '';
                    end
                end
            end
    
            hold off;
        end

        move(c) = prediction;
    end
    disp(move);
    close;
end

