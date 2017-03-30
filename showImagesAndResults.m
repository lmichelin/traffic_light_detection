function Film = showImagesAndResults(start,stop, directory)

% touches :
% a pour reculer d'une image
% w pour reculer rapidement
% d pour avancer d'une image
% x pour avancer rapidement
% f pour filmer
% q pour quitter

nrMaxima = 5;
boxSize = 21;
seuil = 0.25;
maxSize = boxSize;
nb_maxs = 3; %nombre de maxs nécessaires dans le filtre size pour rejeter les grandes zones de rouge
seuil2 = 0.16; %seuil du filtre size
%voisinage_size = 30; 
proportionYmax = 0.3; % on ne va pas chercher les feux rouges plus bas

xmax=[];
ymax =[];
Film = struct('cdata',[],'colormap',[]);
Film_indice = 1;
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
    %current_lab = sprintf('%s/lab_%06d.jpg', directory,indice);
    %lab = imread(current_lab);
    %size(lab) %c'est une matrice de vecteurs de taille 3. Il y a 480 lignes et 640 colonnes. Taille 480*640*3 
    %lab(1:10,1:10,1:3)
    %L* est la clarté, qui va de 0 (noir) à 100 (blanc).
    %a* représente une gamme de 600 niveaux sur un axe vert (−300) → rouge (+299).
    %b* représente une gamme de 600 niveaux sur un axe bleu (−300) → jaune (+299).
    %labmult=lab*255;
    %min(min(labmult))
    %max(max(labmult))
    %Si on multiplie la matrice par 255 on obtient une image blanche et la matrice ne contient que des 255.
    %subplot(2,2,1);
    %fprintf('%s %s\n',currkey,current_img)
    %imagesc(frame)
    %axis equal tight
    %title('Origin RGB frame')
    %subplot(2,2,2);
    %imagesc(lab)
    %title('Origin Lab image')
    %axis equal tight
    %subplot(2,2,3);
    F=convertColorSpaces(frame);
    %imagesc(F)
    [tailleImgY, tailleImgX] = size(F);
    %title('F')
    %colormap(gray)
    axis equal tight
    %subplot(2,2,4);
    imagesc(frame)
    xmax_prev = xmax;
    ymax_prev = ymax;
    [xmax,ymax,maximas] = detectMaxima(F(1 : floor(tailleImgY*proportionYmax) , 1 : tailleImgX),nrMaxima,boxSize);
    
    %zone de detection
    rectangle('position',[1,1,tailleImgX,floor(tailleImgY*proportionYmax)], 'EdgeColor', 'y')
    passed = filterDetectionsThreshold(xmax, ymax, F, seuil);
    passed = passed .* filterDetectionsSize( xmax, ymax, F, maxSize, nb_maxs, seuil2);
    %passed = passed .* filterDetectionsRepetition(xmax,ymax,xmax_prev,ymax_prev,voisinage_size);
    for i=1:nrMaxima
        if passed(i)
            posx = xmax(i)-(boxSize-1)/2;
            posy = ymax(i)-(boxSize-1)/2;
            if posx < 0
                newBoxSizeX = boxSize + posx;
                newPosX = 0;
            else
                newPosX = posx;
                newBoxSizeX = boxSize;
            end
            if posy < 0
                newBoxSizeY = boxSize + posy;
                newPosY = 0;
            else
                newPosY = posy;
                newBoxSizeY = boxSize;
            end

            newBoxSizeX = min(tailleImgX-newPosX,newBoxSizeX);
            newBoxSizeY = min(tailleImgY-newPosY,newBoxSizeY);

            rectangle('position',[xmax(i)-1,ymax(i)-1,2,2], 'EdgeColor', 'b')
            rectangle('position',[newPosX,newPosY,newBoxSizeX-1,newBoxSizeY-1], 'EdgeColor', 'r')
        end
    end
    
    axis equal tight
    title(current_frame)
    if (currkey ~= 'w' & currkey ~= 'x'& currkey ~= 'f')
        pause; % wait for a keypress
    else
        pause(0.02);
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
                indice = indice + 10;
            end
        case 'f'
            if indice < stop
                indice = indice +1;
                Film(Film_indice) = getframe;
                Film_indice = Film_indice + 1;
            end
        case 'q'
            close all
            break
    end
    
end
end
