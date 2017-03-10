function y = showImagesAndResults(start,stop, directory)

% touches :
% a pour reculer d'une image
% w pour reculer rapidement
% d pour avancer d'une image
% x pour avancer rapidement
% q pour quitter

nrMaxima = 3;
boxSize = 15;

if start>stop
    error('start doit être inférieur ou égal à stop')
end

indice = start;
currkey = '0';
while(1)
    current_frame = sprintf('%s/frame_%06d.jpg', directory,indice);
    frame = imread(current_frame);
    %size(frame) %c'est une matrice de vecteurs de taille 3. Il y a 480 lignes et 640 colonnes. Taille 480*640*3 
    %frame(1:10,1:10,1:3) %La matrice prend des valeurs entre 0 et 255.
    %Chaque valeur représente l'intensité de la couleur correspondante (rouge, vert, ou bleu)
    current_lab = sprintf('%s/lab_%06d.jpg', directory,indice);
    lab = imread(current_lab);
    %size(lab) %c'est une matrice de vecteurs de taille 3. Il y a 480 lignes et 640 colonnes. Taille 480*640*3 
    %lab(1:10,1:10,1:3)
    %L* est la clarté, qui va de 0 (noir) à 100 (blanc).
    %a* représente une gamme de 600 niveaux sur un axe vert (−300) → rouge (+299).
    %b* représente une gamme de 600 niveaux sur un axe bleu (−300) → jaune (+299).
    %labmult=lab*255;
    %min(min(labmult))
    %max(max(labmult))
    %Si on multiplie la matrice par 255 on obtient une image blanche et la matrice ne contient que des 255.
    subplot(2,2,1);
    %fprintf('%s %s\n',currkey,current_img)
    imagesc(frame)
    axis equal tight
    title('Origin RGB frame')
    subplot(2,2,2);
    imagesc(lab)
    title('Origin Lab image')
    axis equal tight
    subplot(2,2,3);
    F=convertColorSpaces(frame);
    imagesc(F)
    title('F')
    colormap(gray)
    axis equal tight
    subplot(2,2,4);
    imagesc(frame)
    
    [xmax,ymax,maximas] = detectMaxima(F,nrMaxima,boxSize);
    
    for i=1:nrMaxima
        rectangle('position',[xmax(i)-(boxSize-1)/2,ymax(i)-(boxSize-1)/2,boxSize,boxSize], 'EdgeColor', 'r')
    end
    
    axis equal tight
    title('Maximas')
    if (currkey ~= 'w' & currkey ~= 'x')
        pause; % wait for a keypress
    else
        pause(0.01);
    end
    currkey=get(gcf,'CurrentKey');
    switch currkey
        case 'a'
            if indice > start
                indice = indice - 1;
            end
        case 'd'
            if indice < stop
                indice = indice + 1;
            end
        case 'w'
            if indice > start
                indice = indice - 1;
            end
        case 'x'
            if indice < stop
                indice = indice + 1;
            end
        case 'q'
            close all
            break
    end
    
end
end
