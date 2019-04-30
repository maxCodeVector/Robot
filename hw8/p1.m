function p1

clc;
clear;
close all; % figure(1)is already generate
hold on
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);

r=250;
xc=300;
yc=0;
t = 0 :.01 : pi; 
x = r * cos(t) + xc; 
y = r * sin(t) + yc; 
plot(x, y,'k','LineWidth',2);
plot(xc, yc,'.r','LineWidth',5);

xc=300;
yc=400;
t = 0 : .01 : pi; 
x = r * cos(t) + xc; 
y = -r * sin(t) + yc; 
plot(x, y,'k','LineWidth',2);
plot(xc, yc,'.r','LineWidth',5);

r=632;
xc=0;
yc=0;
t = 0 : .01 : pi/2; 
x = r * cos(t) + xc; 
y = r * sin(t) + yc; 
plot(x, y,'k','LineWidth',2);
plot(xc, yc,'.r','LineWidth',5);

figure(2) % figure(2) you should generate sample base on figure(1)
mu=0;
sigma=15;

%% =============draw sample1 ================
r=250;
xc=300;
yc=0;
t = 0 :.01 : pi; 
samples1 = zeros(length(t), 3);
i = 1;
mu = r;
while i <= length(samples1)
    r = normrnd(mu, sigma);
    samples1(i, 1) = r * cos(t(i)) + xc;  
    samples1(i, 2) = r * sin(t(i)) + yc; 
    i = i+1;
end

%% =============draw sample2=============
r=250;
xc=300;
yc=400;
t = 0 :.01 : pi; 
samples2 = zeros(length(t), 3);
i = 1;
mu = r;
while i <= length(samples2)
    r = normrnd(mu, sigma);
    samples2(i, 1) = r * cos(t(i)) + xc;  
    samples2(i, 2) = -r * sin(t(i)) + yc; 
    i = i+1;
end

%% =============draw sample3======

r=632;
xc=0;
yc=0;
t = 0 : .005 : pi/2;
samples3 = zeros(length(t), 3);
i = 1;
mu = r;
while i <= length(samples3)
    r = normrnd(mu, sigma);
    samples3(i, 1) = r * cos(t(i)) + xc;  
    samples3(i, 2) = r * sin(t(i)) + yc; 
    i = i+1;
end
scatter(samples1(:, 1), samples1(:, 2), '.');
hold on
scatter(samples2(:, 1), samples2(:, 2), '.');
hold on
scatter(samples3(:, 1), samples3(:, 2), '.');

%% =================================
hold on
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);% generate you your sample point here

target = [530, 200];
circleplot(target(1),target(2),20,pi) % drawing the robot

%% figure(3) implement your resampling algorithm 
figure(3)
hold on
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]); 

center = [
    300, 0;
    300, 400;
    0, 0;
];

cacweight(samples1, 1);
cacweight(samples2, 2);
cacweight(samples3, 3);

allsample=[samples1;samples2;samples3];

for i=2:length(allsample)
    allsample(i, 3) = allsample(i-1, 3) + allsample(i, 3);
end

for i=1:length(allsample)
    allsample(i, 3) = allsample(i, 3)/allsample(length(allsample), 3);
end


circleplot(target(1),target(2),20,pi) % drawing the robot
N = 50;
res = zeros(N, 2);
resnum = 1;
for i=1:N
    chooseyou = rand(1);
    for j=1:length(allsample)
        if allsample(j, 3) > chooseyou
            res(resnum, 1) = allsample(j, 1);
            res(resnum, 2) = allsample(j, 2);
            resnum = resnum + 1;
            break;
        end
    end
end

hold on

scatter(res(:, 1), res(:, 2), '.');


    function circleplot(xc, yc, r, theta) 
        t = 0 : .01 : 2*pi; 
        x = r * cos(t) + xc; 
        y = r * sin(t) + yc; 
        plot(x, y,'r','LineWidth',2);
        t2 = 0 : .01 : r; 
        x = t2 * cos(theta) + xc; 
        y = t2 * sin(theta) + yc; 
        plot(x, y,'r','LineWidth',2);
    end

    function cacweight(sample, tag)
        i = 1;
        dhat1 = norm(target-center(1,:));
        dhat2 = norm(target-center(2,:));
        dhat3 = norm(target-center(3,:));
        while i <= length(sample)
            weightd1 = dhat1 - norm([sample(i, 1), sample(i, 2)]-center(1, :));
            weightd2 = dhat2 - norm([sample(i, 1), sample(i, 2)]-center(2, :));
            weightd3 = dhat3 - norm([sample(i, 1), sample(i, 2)]-center(3, :));
            weight = normpdf(weightd1, 0, 30)*...
                normpdf(weightd2, 0, 30)*normpdf(weightd3, 0, 30);
            if tag==1
               samples1(i, 3) = weight;
            elseif tag == 2
               samples2(i, 3) = weight; 
            else
               samples3(i, 3) = weight;
            end
            i = i+1;
        end
    end


end

