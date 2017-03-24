function [ passed ] = filterDetectionsSize( x, y, F, maxSize,nb_maxs,seuil)
%filter large red region
if mod(maxSize, 2) == 0
    error('maxSize doit être un entier impair')
end
[size_y, size_x] = size (F);

passed = ones(size(x));

for i=1:size(x)
    region_x_min=x(i) - (maxSize-1)/2;
    region_y_min=y(i) - (maxSize-1)/2;
    region_x_max=x(i) + (maxSize-1)/2;
    region_y_max=y(i) + (maxSize-1)/2;
    
    safe_y_min = max(region_y_min, 1);
    safe_y_max = min(region_y_max, size_y);
    safe_x_min = max(region_x_min, 1);
    safe_x_max = min(region_x_max, size_x);
    width=safe_x_max-safe_x_min;
    height=safe_y_max-safe_y_min;
    bord=zeros((width+height)*2, 2);
    
    bord(1:width,1:2)=F(safe_y_min:safe_y_min+1, safe_x_min:safe_x_max-1)';
    bord(width+1:width+height,1:2)=F(safe_y_min:safe_y_max-1, safe_x_max-1:safe_x_max);
    bord(width+1+height:2*width+height,1:2)=F(safe_y_max-1:safe_y_max, safe_x_min+1:safe_x_max)';
    bord(2*width+1+height:2*width+2*height,1:2)=F(safe_y_min+1:safe_y_max, safe_x_min:safe_x_min+1);
    
    for j=1:nb_maxs
        [maxs, lignes] = max(bord);
        [max_b, colonne] = max(maxs);
        ligne = lignes(colonne);
        bord(ligne,colonne)=0;
    end
    if max_b > seuil
        passed(i)=0;
    end

end

