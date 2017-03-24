function [ passed ] = filterDetectionsThreshold( x, y, F, Threshold )

passed = ones(size(x));
for i = 1:size(x)
    if F(y(i), x(i)) < Threshold
       passed(i) = 0;
    end
end

end

