function [xb, yb, zb] = cob(params)
    massBallast = 300; %grams 
    massSoad = 2*360; %grams
    volumeMass = 50*0.47625^2*pi %cm^3
    massMast = volumeMast*densityMast; %grams
    massBoat = massMast + massSoda + massBallast; %grams
    
    densityWater = 1; %g/cm^3
    massWater = massBoat; %g
    volumeWater = massWater / densityWater; %cm^3 
    
    n = params(1);
    a = params(2);
    b = params(3);
    c = params(4);
    
    fun = @(z, y, x) abs(y).^n + a*x.^2 + b*x + c; 
    
    %case 1 - waterline doesn't intersect top of boat 
%     zmin = fun;
%     ymin = @(x) a*x^2 + b*x + c; 
%     ymax = 0; 
%     xmin = (-b-sqrt(b^2-4*a*c)/(2*a); 
%     xmax = (-b+sqrt(b^2-4*a*c)/(2*a);
%     
%     
%     waterVolumeFun = @d integral3(fun, zmin, d, ymin, ymax, xmin, xmax); 
%     
    %case 2 - waterline intersects top of boat 
    
    while d > bottomBoat
end 
