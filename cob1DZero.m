function c = cob1DZero(theta, width, length1, depth, n)  
    clf
    hold on
%     options = optimoptions('fsolve', 'display', 'none');
    % com min = - 16 cm, com max = 1 cm 

    s = BoatCalcBugZero(theta, width, length1, depth, n); 
    d = s(1);
    volumeWater = s(2);
    
    fWaterLine = @(x) tan(theta)*x + d;
%     fBoat = @(x) depth*abs(x/(width/2))^n - depth;
%     ezplot(fWaterLine, [-width/2 width/2]) 
%     ezplot(fBoat, [-width/2 width/2])
% %     
    x1IntersectFun = @(x) depth*abs(x/(width/2)).^n - depth - (tan(theta).*x + d); 
    x(1) = fzero(x1IntersectFun, -width/2);
    x(2) = fzero(x1IntersectFun, width/2);
    x2 = fzero(fWaterLine, -width/2);
   
    if theta < pi / 2
        % cob in x direction 
        fX1 = @(x) x.*(tan(theta).*x + d) - x.*(depth*abs(x/(width/2)).^n - depth); %area between hull and waterline * x
        fX2 = @(x) -x.*(depth.*abs(x/(width/2)).^n - depth); % area between hull top of boat * x

        if abs(x(1) - x(2)) > 0.01 && abs(x(2)) < width/2 %two intersect points of the waterline and hull
            cobX = length1*integral(fX1, x(1), x(2)) / volumeWater; 
        else % waterline intersects hull of boat and top of boat
            cobX = (length1*(integral(fX1, x(1), x2) + integral(fX2, x2, width/2))) / volumeWater;
        end

        %cob in y direction
        fY1 = @(x) ((tan(theta)*x + d).^2 - (depth*abs(x/(width/2)).^n - depth).^2) / 2;
        fY2 = @(x) ((depth*abs(x/(width/2)).^n - depth).^2) / -2;

        if abs(x(1) - x(2)) > 0.01 && abs(x(2)) < width/2 %two intersect points of the waterline and hull
            cobY = length1*integral(fY1, x(1), x(2)) / volumeWater; 
        else % waterline intersects hull of boat and top of boat
            cobY = length1*(integral(fY1, x(1), x2) + integral(fY2, x2, width/2)) / volumeWater; 
        end
    else 
        fX1 = @(x) -x.*(tan(theta).*x + d); % area between waterline and top of boat
        fX2 = @(x) -x.*(depth*abs(x/(width/2)).^n - depth); %area between hull and top of boat
        
        if abs(x(1) - x(2)) > 0.01 && abs(x(1)) < width/2 %two intersect points of waterline and hull
            cobX = length1*integral(fX2, -width/2, x(1)); 
            cobX = cobX + length1*integral(fX1, x(1), x(2)); 
            cobX = cobX + length1*integral(fX2, x(2), width/2); 
            cobX = cobX./volumeWater; 
        else % only one intersect point of waterline and hull
            cobX = length1*integral(fX1, x2, x(2)); 
            cobX = cobX + length1*integral(fX2, x(2), width/2);
            cobX = cobX/volumeWater; 
        end
        
        fY1 = @(x) (-(tan(theta).*x + d).^2)./2;
        fY2 = @(x) (-(depth*abs(x/(width/2)).^n - depth).^2)./2;
        
        if abs(x(1) - x(2)) > 0.01 && abs(x(1)) < width/2 %two intersect points of waterline and hull
            cobY = length1*integral(fY2, -width/2, x(1)); 
            cobY = cobY + length1*integral(fY1, x(1), x(2)); 
            cobY = cobY + length1*integral(fY2, x(2), width/2); 
            cobY = cobY./volumeWater; 
        else % only one intersect point of waterline and hull
            cobY = length1*integral(fY1, x2, x(2))/volumeWater;
            cobY = cobY + length1*integral(fY2, x(2), width/2)/volumeWater;
        end
    end
    
    c(1) = cobX;
    c(2) = cobY;
    c(3) = volumeWater; 
end 
    
    