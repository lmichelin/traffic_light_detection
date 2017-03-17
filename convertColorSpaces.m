function imageRedGreen = convertColorSpaces(imageRGB)

    colorTransform = makecform('srgb2lab');
    labimg = applycform(imageRGB, colorTransform);

    lab16 = uint16(labimg);
    
    imageRedGreenSum =   double(lab16(:,:,2)) + double(lab16(:,:,3)) ;
    imageLuminance = double(lab16(:,:,1))/255. ;
    imageRedGreenSum = (imageRedGreenSum-256.)/256. ;
    imageRedGreen = imageRedGreenSum .* imageLuminance ;
end


