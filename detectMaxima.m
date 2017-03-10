function  [x,y,maxVals] = detectMaxima(F, nrMaxima, boxSize)

if mod(boxSize, 2) == 0
    error('boxSize doit être un entier impair')
end

x = [];
y = [];
maxVals = [];

for i=1:nrMaxima
    [maxs, lignes] = max(F);
    [max_val, colonne] = max(maxs);
    ligne = lignes(colonne);
    
    x = [x;colonne];
    y = [y;ligne];
    maxVals = [maxVals;max_val];
    
    
    [size_y, size_x] = size (F);
    
    region_x_min=colonne - (boxSize-1)/2;
    region_y_min=ligne - (boxSize-1)/2;
    region_x_max=colonne + (boxSize-1)/2;
    region_y_max=ligne + (boxSize-1)/2;
    
    safe_y_min = max(region_y_min, 1);
    safe_y_max = min(region_y_max, size_y);
    safe_x_min = max(region_x_min, 1);
    safe_x_max = min(region_x_max, size_x);
    
    F(safe_y_min : safe_y_max , safe_x_min : safe_x_max) = 0;
end
    
end

  



