function z = globalhull(x, y, params)
    n = params(1);
    a = params(2);
    b = params(3);
    c = params(4); 
    z = abs(y).^n + a*x^2 + b*x + c; 
    if z >= 0
        z = 0;
    end 

end 

function [xm, ym, zm] = com(params)
    densityBoat = 0.2; %g/cm^3 
    densityWater = 1; %g/cm^3
    
    n = params(1);
    a = params(2);
    b = params(3);
    c = params(4);
    
    
end

