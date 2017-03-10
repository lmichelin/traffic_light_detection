function [imageRedGreen, labimg] = convertColorSpaces(imageRGB)
colorTransform = makecform('srgb2lab');
labimg = applycform(imageRGB, colorTransform);

lab16 = uint16(labimg);

 % ensuite creer la matrice F
F = lab16(:,:,1) .* (lab16(:,:,2) + lab16(:,:,3));
imageRedGreen = F;
end


