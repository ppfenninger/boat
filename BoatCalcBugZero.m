function s = BoatCalcBugZero(theta, width, length1, depth, n)
    fun = @(x) depth*(abs(x/(width/2)).^n) - depth; %function for the hull of boat

    % vBoat = abs(length*integral(fun, width/-2, width/2)); %cm^3 %volume of boat
    mBoat = 730+96+300; % g % mass of boat

    densityWater = 1; % g/cm^3
    vWater = mBoat / densityWater; %cm^3 %volume water displaced by boat

    dx = 0.01;
    topBoat = 0; %cm %x axis
    bottomBoat = -1*depth; %cm 

    step = (topBoat - bottomBoat) * dx;
    if theta < pi/2
        d = floor(-tan(theta)*(-width/2));
    else
        d = floor(-tan(theta)*(width/2));
    end
    waterLine = 0; 
    max1 = realmax; 

    while d > bottomBoat - 100
        if theta < pi/2
            fun2 = @(x) tan(theta)*x + d - (depth*abs(x/(width/2)).^n - depth); % function for integral to calculate volume between hull and line
            x(1) = fzero(fun2, -width/2); % actual intercept location
            x(2) = fzero(fun2, width/2);


            waterLineFun = @(x2) tan(theta)*x2 + d; % equation for intercept of water line and x-axis (top of boat)
            waterLineAxisIntercept = fzero(waterLineFun, 0);  

            if abs(x(1) - x(2)) < 0.01 || abs(x(2)) > width/2
                volume = abs(length1*integral(fun2, x(1), waterLineAxisIntercept)); %between hull and line
                volume = volume + abs(length1*integral(fun, waterLineAxisIntercept, width/2)); % between hull and top of boat
            else %line intercepts the hull
                volume = abs(length1*integral(fun2, x(1), x(2))); % between hull and line (entire volume)
            end

            if volume < 0
                %break code
            end

            if abs(volume - vWater) < max1 
                waterLine = d;
                max1 = abs(volume - vWater);
                fVolume = volume;
            elseif abs(theta - pi/2) > pi/100
                break
            end

            d = d - step; 
        else % if theta > pi/2 %need to calculate the integrals on the other side of the boat
            fun2 = @(x) (depth*abs(x/(width/2)).^n - depth) - (tan(theta)*x + d); % function for integral to calculate volume between hull and line
            x(1) = fzero(fun2, -width/2);% actual intercept location
            x(2) = fzero(fun2, width/2);


            waterLineFun = @(x2) (tan(theta)*x2 + d); % equation for intercept of water line and x-axis (top of boat)
            waterLineAxisIntercept = fzero(waterLineFun, 0);  

            if abs(x(1) - x(2)) < 0.01 || abs(x(1)) > width/2
                volume = abs(length1*integral(waterLineFun, waterLineAxisIntercept, x(2))); %between hull and line
                volume = volume + abs(length1*integral(fun, x(2), width/2)); % between hull and top of boat
            else %line intercepts the hull twice 
                volume = abs(length1*integral(fun, -width/2, x(1))); % between hull and line (entire volume)
                volume = volume + abs(length1*integral(waterLineFun, x(1), x(2)));
                volume = volume + abs(length1*integral(fun, x(2), width/2));
                
            end
            
            if abs(volume - vWater) < max1 
                waterLine = d;
                max1 = abs(volume - vWater);
                fVolume = volume;
            else
                break
            end

            d = d - step;     
        end
    end

    s = [waterLine, fVolume];
end

