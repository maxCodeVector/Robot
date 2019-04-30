# Homework 5

111610303 黄玉安



### Problem 1: Please generate samples of the normal, triangular, and abs(x) distributions (N=10^6)

Those figure above are my result. All source code is in `distribution.m`. I sample 1000000 times, there is a parameter b = 1 in those functions which represent domain I care about.

**Normal**

![Screenshot from 2019-04-08 10-35-57](/home/hya/Pictures/Screenshot from 2019-04-08 10-35-57.png)

The function of normal distributions:

```matlab
 function a = norm(x)
       a0 = 1/sqrt(2*pi*b*b); 
       a = a0*exp(-x*x/(2*b*b));
 end
 
```

**Triangular**

![Screenshot from 2019-04-08 10-43-36](/home/hya/Pictures/Screenshot from 2019-04-08 10-43-36.png)


The function of normal distributions:
```matlab
function a = tri(x)
        a1 = 1/(sqrt(6)*b);
        a2 = abs(x)/(6*b*b);
        a = max(0, a1-a2);
end 
```


**abs(x)**

![Screenshot from 2019-04-08 10-40-14](/home/hya/Pictures/Screenshot from 2019-04-08 10-40-14.png)

```matlab
function a = f(x)
       if (x>-b) && (x<b)
        a = abs(x);
       else
        a = 0;
       end
    end

```
I use function sample() to do the sampling.
```matlab
function sample()
        maxV = tri(0);
       % maxV = b;
        
        for c = 1:n
            a = 0;
            y = 1;
            
            while(y>tri(a))
                a = unifrnd (-3*b,3*b);
                y = unifrnd (0,maxV); % if this is function abs(x)
            end
            x(c) = a;
        end
        figure('name', 'histogram auto');
        
        h = histogram(x);
        h.Normalization = 'probability';
end

```
The max value of norm and triangular is at x=0, and for abs(x), it is parameter b.


### Problem 2: Please generate samples of the odometry-based motion model (N=500).

I use the code that teacher assistant provided and do some modification (distribution.m). 30 is too much. I cut it to 20. This is my result.

![Screenshot from 2019-04-08 11-13-48](/home/hya/Pictures/Screenshot from 2019-04-08 11-13-48.png)



### Problem 3: Please generate samples of the velocity-based motion model for following cases (N=500)

I follow the algorithm in this figure

![Screenshot from 2019-04-08 17-16-25](/home/hya/Pictures/Screenshot from 2019-04-08 17-16-25.png)

My initial speed and position:v=10, w=0.5, at position (0, 0) with degree pi/6:

I have 6 parameters a1, a2, a3, a4, a5, a6. Most of them is 0. All code about this question is in velocity.m.

```
v = ones(2,1);
w = ones(2, 1);
v(1) = 10;
w(1) = 0.5;


x = zeros(n, 1);
y = zeros(n, 1);
theta = zeros(n, 1);
theta(1) = pi/6;

```

**figure 1**

a1 = 0.001

a4 = 5

![Screenshot from 2019-04-08 16-11-06](/home/hya/Pictures/Screenshot from 2019-04-08 16-11-06.png)

**figure 2**

a1 = 0.01

a4 =  2

![Screenshot from 2019-04-08 16-12-51](/home/hya/Pictures/Screenshot from 2019-04-08 16-12-51.png)

**fugure 3**

a1 = 0.0005

a4 = 10

![Screenshot from 2019-04-08 16-14-14](/home/hya/Pictures/Screenshot from 2019-04-08 16-14-14.png)



### Problem 4: Please generate the map-consistent probability model in the following situation.

I set a barrier in the figure. Using code:

```matlab
barrier = [0.6, 0.5, 0.5, 0.05];
rectangle('Position',barrier)  %给定起点[x,y]  矩形宽w高h
```
result is:

![Screenshot from 2019-04-08 16-50-54](/home/hya/Pictures/Screenshot from 2019-04-08 16-50-54.png)



And them set if the position of sample result is in this barrier, then resample it.

```matlab
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

```

The result is:

![Screenshot from 2019-04-08 16-52-39](/home/hya/Pictures/Screenshot from 2019-04-08 16-52-39.png)

 All code of problem 3 and 4 are in velocity.m.