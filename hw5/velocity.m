function velocity()

a1 = 0.005;
a2 = 0;
a3 = 0;
a4 = 10;
a5 = 0;
a6 = 0;


n = 500;
dt = 0.1;
v = ones(2,1);
w = ones(2, 1);
v(1) = 10;
w(1) = 0.5;


x = zeros(n, 1);
y = zeros(n, 1);
theta = zeros(n, 1);
theta(1) = pi/6;
plot(x(1), y(1), 'o');
hold on



barrier = [0.6, 0.5, 0.5, 0.05];
rectangle('Position',barrier)  %给定起点[x,y]  矩形宽w高h

function sample(X)
    while 1
        r = normrnd(0,(a5*v(1)^2 + a6*w(1)^2));
        v(2) = v(1) + normrnd(0,(a1*v(1)^2 + a2*w(1)^2));
        w(2) = w(1) + normrnd(0,(a3*v(1)^2 + a4*w(1)^2));

        rr = v(2)/w(2);
        x(k+1)=X(1)-rr*sin(X(3))+rr*sin(X(3)+w(2)*dt);
        y(k+1)=X(2)+rr*cos(X(3))-rr*cos(X(3)+w(2)*dt);
        theta(k+1)=X(3)+w(2)*dt+r*dt;
        if(y(k+1)<0.49 || y(k+1)>0.56)
            break;
        end
    end
end

for k = 1:n
    sample([x(1), y(1), theta(1)]);
end

scatter(x, y, '.');

end