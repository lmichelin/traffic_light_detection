function imageRedGreen = convertColorSpaces(imageRGB)
colorTransform = makecform('srgb2lab');
labimg = applycform(imageRGB, colorTransform);

lab16 = uint16(labimg);

imageRedGreen = lab16(:,:,1) .* (lab16(:,:,2) + lab16(:,:,3));
end


