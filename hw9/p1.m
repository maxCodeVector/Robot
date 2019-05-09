clc;clear;
close all;
x=10;
y=10;

lmx=[x-5,x-5,x+5,x+5];
lmy=[y-5,y+5,y-5,y+5];
axis([0 20 0 20]);
for i=1:4
    hold on
    circleplot(lmx(i),lmy(i),0.5, 'r');
end

rr= zeros(1, 4);
rectangle('position',[9.5,9.5,1,1]);

for i=1:4
    rr(i)=((lmx(i)-x)^2+(lmy(i)-y)^2)^(1/2);
end


% add noise
nr= zeros(1, 4);
for i=1:4
    nr(i)=rr(i)+normrnd(0,1);
end
k= zeros(1, 4);
k(1)=abs(nr(1)-nr(4));
k(2)=abs(nr(4)-nr(3));
k(3)=abs(nr(3)-nr(2));
k(4)=abs(nr(2)-nr(1));
init_min=k(1);
for i=2:4
    if init_min<k(i)
        init_min=k(i);
    end
end
k(1)=abs(nr(1)+nr(4));
k(2)=abs(nr(4)+nr(3));
k(3)=abs(nr(3)+nr(2));
k(4)=abs(nr(2)+nr(1));
init_max=k(1);
for i=2:4
    if init_max>k(i)
        init_max=k(i);
    end
end
init_solve=(init_min+init_max)/2;


f=@(a)(sqrt((a+nr(1)+nr(4))*(a-nr(1)+nr(4))*(a+nr(1)-nr(4))*(nr(1)+nr(4)-a)) + ...
    sqrt((a+nr(3)+nr(4))*(a-nr(3)+nr(4))*(a+nr(3)-nr(4))*(nr(3)+nr(4)-a)) +...
    sqrt((a+nr(3)+nr(2))*(a-nr(3)+nr(2))*(a+nr(3)-nr(2))*(nr(3)+nr(2)-a)) +...
    sqrt((a+nr(1)+nr(2))*(a-nr(1)+nr(2))*(a+nr(1)-nr(2))*(nr(1)+nr(2)-a))  -4*a*a );
a=fsolve(f,init_solve);

yy1=sqrt((a+nr(1)+nr(4))*(a-nr(1)+nr(4))*(a+nr(1)-nr(4))*(nr(1)+nr(4)-a))/(2*a);
xx1=sqrt((a+nr(3)+nr(4))*(a-nr(3)+nr(4))*(a+nr(3)-nr(4))*(nr(3)+nr(4)-a))/(2*a);
yy2=sqrt((a+nr(3)+nr(2))*(a-nr(3)+nr(2))*(a+nr(3)-nr(2))*(nr(3)+nr(2)-a))/(2*a);
xx2=sqrt((a+nr(1)+nr(2))*(a-nr(1)+nr(2))*(a+nr(1)-nr(2))*(nr(1)+nr(2)-a)) /(2*a);

circleplot(x+xx1,y+yy1,0.4, 'b');
circleplot(x+xx1,y-yy2,0.4, 'b');
circleplot(x-xx2,y-yy2,0.4, 'b');
circleplot(x-xx2,y+yy1,0.4, 'b');



function circleplot(xc, yc, r, color) 
        t = 0 : .01 : 2*pi; 
        x = r * cos(t) + xc; 
        y = r * sin(t) + yc; 
        plot(x, y,color,'LineWidth',2);
        %t2 = 0 : .01 : r; 
        %x = t2 * cos(theta) + xc; 
        %y = t2 * sin(theta) + yc; 
        %plot(x, y,'r','LineWidth',2);
end

