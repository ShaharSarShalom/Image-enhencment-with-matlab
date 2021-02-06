sprintf('start\n'); 
clear all;
%%
temp = '?????????????';
feature('DefaultCharacterSet', 'UTF8') %# for all Character support
feature('DefaultCharacterSet', 'Windows-1250') %# for all Character support

srcDir = 'C:\Users\Shahar Sar Shalom .DESKTOP-OF8R54E\Dropbox\Nakdimon_Shahar\???';
dstDir = 'C:\Users\Shahar Sar Shalom .DESKTOP-OF8R54E\Dropbox\Nakdimon_Shahar\???_?????_???_????';

files = dir([srcDir, '\*.jpg']);
sz = size(files);
%%
for i = 1:sz(1)
    file = files(i).name;
    img = imread([srcDir '\' file]);
    imgSize = size(img);
    if false
        imshow(img);
    end
    imgGray = rgb2gray(img);
    maskGrayThreshold = 25; 
    if false
        imshow(imgGray);
    end
    imgGrayMask = imgGray > maskGrayThreshold; 
    
    if false
        imshow(imgGrayMask);
    end
    
    se1 = strel('square', 11);
    imgGrayMaskDilated = imdilate(imgGrayMask,se1,'full');
    
      if false
        imshow(imgGrayMaskDilated);
      end
    
      % Find the left top, buttom right 
      t = find(imgGrayMaskDilated == 1);
      corX = mod(t,imgSize(2));
      corY = t / imgSize(2);
      
      min(corX)
    
    % imgSize(1) - rows, imgSize(2) - cols
    if imgSize(1) == 1872 && imgSize(2) == 2520
        rect = [0029.5    0053.5    2469.0    1646.0];
        imgRoi = imcrop(img, rect);
    elseif imgSize(2) == 1872 && imgSize(1) == 2520
        rect = [0131.5    0034.5    1619.0    2460.0];
        imgRoi = imcrop(img, rect);
    elseif imgSize(1) == 1872 && imgSize(2) == 2520
        rect = [0131.5    0034.5    1619.0    2460.0];
        imgRoi = imcrop(img, rect);
    elseif imgSize(2) == 1872 && imgSize(1) == 2520
        rect = [0131.5    0034.5    1619.0    2460.0];
        imgRoi = imcrop(img, rect);
    else 
        imgRoi = img;
    end
    if false
        imshow(imgRoi);
    end
    
    imgRoiOutput = imgRoi;
    %% Histogram equalization on all channels
    if true
    imgRoiOutput = histeq(imgRoiOutput);
    if false
        imshowpair(imgRoiOutput, imgRoi, 'montage');
    end
    end
    
    %% Equlize histogram HSV --> on value channel only
    if false
        hsv = rgb2hsv(imgRoi);
        value = hsv(:,:,3);
        valueEq = histeq(value);
        hsvEuqalized = cat(3, hsv(:,:,1), hsv(:,:,2), valueEq);
        imgRoiOutput2 = hsv2rgb(hsvEuqalized);
        imgRoiOutput = imgRoiOutput2;
        %imshowpair(imgRoiOutput2, imgRoi, 'montage');
        %imshowpair(imgRoiOutput, imgRoiOutput2, 'montage');
    end
    
    %% Apply Local histogram on HSV value channel only
    if true
        try
            hsv = rgb2hsv(imgRoiOutput);
            value = hsv(:,:,3);
            valueEq = adapthisteq(value);
            
            %% Apply local histogram
            imgRoiSz = floor([ size(imgRoi,1) size(imgRoi,2) ] / 256);
            valueEq = adapthisteq(value,'NumTiles',imgRoiSz);
            if false
                imshowpair(valueEq, imgRoi, 'montage');
            end
            
            hsvEuqalized = cat(3, hsv(:,:,1), hsv(:,:,2), valueEq);
            imgRoiOutput3 = hsv2rgb(hsvEuqalized);
            
            if false
                imshowpair(imgRoiOutput3, imgRoi, 'montage');
                imshowpair(imgRoiOutput3, imgRoiOutput, 'montage');
            end
            imgRoiOutput = imgRoiOutput3;
        catch ME
            warning('Exception occurred');
        end
    end
    %imshowpair(imgRoiOutput3, imgRoi, 'montage');
    %imshowpair(imgRoiOutput, imgRoiOutput3, 'montage');
    %imshowpair(imgRoiOutput2, imgRoiOutput3, 'montage');
    
    %% Apply intensity - fuzzy logic histogram equalization
    %imgRoiOutput = localhist(imgRoi);
    % rgbInputImage = imread('peppers.png');
    %     rgbInputImage = imgRoi;
    %       labInputImage = applycform(rgbInputImage,makecform('srgb2lab'));
    %     Lbpdfhe = fcnBPDFHE(labInputImage(:,:,1));
    %  labOutputImage = cat(3,Lbpdfhe,labInputImage(:,:,2),labInputImage(:,:,3));
    %  rgbOutputImage = applycform(labOutputImage,makecform('lab2srgb'));
    %imshowpair(rgbOutputImage, imgRoi, 'montage');
    %imshowpair(rgbOutputImage, imgRoiOutput, 'montage');
    %outputImage = fcnBPDFHE(imgRoi);
    if false
        imshow(imgRoiOutput);
    end
    
    %hist3Enhence = autoenhance(imgRoiOutput3);
    %     imshowpair(imgRoiOutput3, hist3Enhence, 'montage');
    
    preImg = imgRoiOutput;
    imgRoiOutput = autoenhance(imgRoiOutput);
    if false
        imshowpair(preImg,imgRoiOutput, 'montage');
    end 
    
    rgbInputImage = imgRoiOutput;
    labInputImage = applycform(rgbInputImage,makecform('srgb2lab'));
    Lbpdfhe = fcnBPDFHE(labInputImage(:,:,1));
    labOutputImage = cat(3,Lbpdfhe,labInputImage(:,:,2),labInputImage(:,:,3));
    rgbOutputImage = applycform(labOutputImage,makecform('lab2srgb'));
    %     imshowpair(rgbOutputImage, histEnhence, 'montage');
    
    if false
        imshow(rgbOutputImage);
    end
    
    imwrite(rgbOutputImage, [dstDir '\' files(i).name]);
end

sprintf('finished');