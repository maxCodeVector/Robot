clc;
clear;
close all;

points = [];
%% figure(1) is already generate
hold on
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);
r=250;
xc=300;
yc=0;
t = 0 :.01 : pi; 
x = r * cos(t) + xc; 
y = r * sin(t) + yc; 
plot(x, y,'k','LineWidth',2)
plot(xc, yc,'.r','LineWidth',5);

xc=300;
yc=400;
t = 0 : .01 : pi;
x = r * cos(t) + xc; 
y = -r * sin(t) + yc;
plot(x, y,'k','LineWidth',2)
plot(xc, yc,'.r','LineWidth',5);

r=632;
xc=0;
yc=0;
t = 0 : .01 : pi/2; 
x = r * cos(t) + xc; 
y = r * sin(t) + yc; 
plot(x, y,'k','LineWidth',2)
plot(xc, yc,'.r','LineWidth',5);

%% figure(2) you should generate sample base on figure(1)
figure(2) 
mu=0;
sigma=25;
hold on
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);

% generate you your sample point here
n = 500;
points = [points circleSample(300, 0, 250, n, mu, sigma)];
points = [points circleSample(300, 400, 250, n, mu, sigma)];
points = [points circleSample(0, 0, 632, n, mu, sigma)];

circleplot(530,200,20,pi) % drawing the robot

weight = [];
maxDis = 400;
[row, c]=size(points);
for col = 1:c
    x = points(1, col);
    y = points(2, col);
    dis = sqrt((x - 530)^2 + (y - 200)^2);
    weight(col) = (maxDis-dis)/maxDis;
end
points = [points; weight];

%% figure(3)
figure(3)
hold on
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);

% figure(3) implement your resampling algorithm 
k = 10; % resample times
for i = 1:k
    [row, col]=size(points);
    delCount = 0;
    for j = 1:col
        w = points(3, j-delCount);
        if rand > w
            points(:, j-delCount) = [];
            delCount = delCount + 1;
        end
    end
end

scatter(points(1, :), points(2, :));
m = mean(points(1, :));
n = mean(points(2, :));
circleplot(m,n,20,pi)


%%
function circleplot(xc, yc, r, theta) 
t = 0 : .01 : 2*pi; 
x = r * cos(t) + xc; 
y = r * sin(t) + yc; 
plot(x, y,'r','LineWidth',2)
t2 = 0 : .01 : r; 
x = t2 * cos(theta) + xc; 
y = t2 * sin(theta) + yc; 
plot(x, y,'r','LineWidth',2)
end

function result=circleSample(xc, yc, r, n, mu, sig)
    theta = rand(1, n) * 2 * pi;
    randr = normrnd(mu, sig, 1, n) + r;
    x = xc + cos(theta).*randr;
    y = yc + sin(theta).*randr;
    scatter(x, y);
    result = [x; y];
end