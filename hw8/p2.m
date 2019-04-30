function p2
clc;
clear;
close all;

%% =============draw sample1 ================

figure(1)
target = [300, 200, pi];
landmark = [
    0,   0,   360, 0, 0;
    600, 0,   360, 0, 0;
    0,   400, 360, 0, 0;
    600, 400, 360, 0, 0;
    300, 0,   220, 0, 0;
    300, 400, 220, 0, 0;
];

for k=1:length(landmark)
    landmark(k, 4) = norm(target(1:2)-[landmark(k, 1), landmark(k, 2)]);
    landmark(k, 5) = atan2(landmark(k, 2)-target(2), landmark(k, 1)-target(1))-target(3);
end


allsample = [];
dsigma = 15;
sigma = 1;
for k=1:length(landmark)
    if k == 1
        t = 0 : .05 : pi/2; 
    elseif k==2 
        t = pi/2 : .05 : pi; 
    elseif k==3
        t = -pi/2 : .05 : 0; 
    elseif k==4 
        t = pi : .05 : 3*pi/2; 
    elseif k==5 
        t = 0 : .05 : pi; 
    elseif k==6 
        t = pi : .05 : 2*pi; 
    end
    i = 1;
    samples = zeros(length(t), 4);
    while i <= length(t)
        r = normrnd(landmark(k, 3), dsigma);
        samples(i, 1) = r * cos(t(i)) + landmark(k, 1);  
        samples(i, 2) = r * sin(t(i)) + landmark(k, 2); 
        samples(i, 3) = normrnd(pi, sigma);
        i = i+1;
    end
    for i=1:length(samples)
       circleo(samples(i, :), 5); 
    end
    allsample = [allsample;samples];
    scatter(landmark(k, 1), landmark(k, 2), 'r');
    hold on
end


%% =================================
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);% generate you your sample point here


circleplot(target(1),target(2),20,pi) % drawing the robot

%% figure(2) implement your resampling algorithm 
figure(2)

for i = 1:length(allsample)
    weight = 1;
    for k = 1:length(landmark)
       weight = normpdf(landmark(k, 4)-norm(...
           [allsample(i, 1), allsample(i, 2)]-[landmark(k, 1), landmark(k, 2)]), 0, 20)*weight;
       weight = normpdf(landmark(k, 5)-atan2(...
           landmark(k, 2)-allsample(i, 2), landmark(k, 1)-allsample(i, 1))-allsample(i, 3), 0, 0.8) * weight;
    end
    allsample(i, 4) = weight;
end


for i=2:length(allsample)
    allsample(i, 4) = allsample(i-1, 4) + allsample(i, 4);
end

for i=1:length(allsample)
    allsample(i, 4) = allsample(i, 4)/allsample(length(allsample), 4);
end


circleplot(target(1),target(2),20,pi) % drawing the robot

N = 150;
res = zeros(N, 3);
resnum = 1;
i = 1;
while i<=N
    chooseyou = rand(1);
    tag = 0;
    for j=1:length(allsample)
        if allsample(j, 4) > chooseyou
            res(resnum, 1) = allsample(j, 1);
            res(resnum, 2) = allsample(j, 2);
            res(resnum, 3) = allsample(j, 3);
            resnum = resnum + 1;
            tag = 1;
            break;
        end
    end
    if tag==1
        i = i+1;
    end
end


%% drew result============================
for i=1:length(res)
   circleo(res(i, :), 5); 
end
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);% generate you your sample point here


circleplot(target(1),target(2),20,pi) % drawing the robot


    function circleplot(xc, yc, r, theta) 
        tt = 0 : .01 : 2*pi; 
        x = r * cos(tt) + xc; 
        y = r * sin(tt) + yc; 
        plot(x, y,'r','LineWidth',2);
        t2 = 0 : .01 : r; 
        x = t2 * cos(theta) + xc; 
        y = t2 * sin(theta) + yc; 
        plot(x, y,'r','LineWidth',2);
        hold on
    end

    function circleo(sample, r) 
        xc = sample(1);
        yc = sample(2);
        theta = sample(3);
        
        tt = 0 : .1 : 2*pi; 
        x = r * cos(tt) + xc; 
        y = r * sin(tt) + yc; 
        plot(x, y,'LineWidth',2);
        t2 = 0 : .1 : r; 
        x = t2 * cos(theta) + xc; 
        y = t2 * sin(theta) + yc; 
        plot(x, y,'LineWidth',2);
        hold on
    end


end

