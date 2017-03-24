function [ passed ] = filterDetectionsRepetition( x, y, x_prev ,y_prev, voisinage_size)
% Eliminer si n'existe pas dans l'image précédente
passed = zeros(size(x));
for i=1:size(x)
    for j=1:size(x_prev)
        if norm([x(i)-x_prev(j),y(i)-y_prev(j)])<voisinage_size
            passed(i) = 1;
        end
    end
end

end

