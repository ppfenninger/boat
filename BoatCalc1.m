densityBoat = 0.5; %g/cm^3
length = 1; % cm
theta = pi/4; %radians 
n = 1.5; 
fun = @(x) abs(x).^n - 1; %function for the hull of boat for given n

vBoat = abs(length*integral(fun, -1, 1)); %cm^3 %volume of boat
mBoat = vBoat*densityBoat; % g % mass of boat

densityWater = 1; % g/cm^3
vWater = mBoat / densityWater; %cm^3 %volume water displaced by boat

dx = 0.001;
topBoat = 0; %cm %x axis
bottomBoat = -1; %cm 

step = (topBoat - bottomBoat) * dx;

d = 0;
waterLine = 0; 
max = realmax; 

while d > bottomBoat
    xfun = @(x1) fun(x1) - tan(theta)*x1 + d; % equation for intercept of waterline and boat hull
    x1 = fzero(xfun, -1); % actual intercept location
    
    x2funAxis = @(x2) tan(theta)*x2 + d; % equation forintercept of water line and x-axis (top of boat)
    x2AxisIntercept = fzero(x2funAxis, -1);  
    
    if x2AxisIntercept > 1 %determining whether the line intercepts the top of the boat or the hull
        x2 = fzero(xfun, x1+dx);  % line intercepts the hull
    else
        x2 = 0; % line intercepts the top of the boat
    end
    
    fun2 = @(x) tan(theta)*x + d - abs(x).^n + 1; % function for integral to calculate volume between hull and line
    
    if x2 == 0 % line intercepts top of boat
        volume = abs(length*integral(fun2, x1, x2AxisIntercept)); %between hull and line
        volume = volume + abs(length*integral(fun, x2AxisIntercept, 1)); % between hull and top of boat
    else %line intercepts the hull
        volume = abs(length*integral(fun2, x1, x2)); % between hull and line (entire volume)
    end
    
    if abs(volume - vWater) < max 
        waterLine = d;
        max = abs(volume - vWater);
    end
    
    d = d - step; 
end

disp(waterLine); % y-intercept of the equation of the water line (tan(theta) is slope)


