# Intelligent Robot Homework 6 Report

**Problem 1: Please generate the beam-based measurement models with a mixture of four distributions (by choosing five different sets of parameters).**

```matlab
% this ara parameter (z_hit, z_short, z_max, z_rand, sigma_hit, z_MAX, lambda_short)
Theta1 = [0.85  0.05  0.05  0.05  0.1  5  1]; % parameter group 1
Theta2 = [0.50  0.15  0.15  0.20  0.5  5  1]; % parameter group 2
Theta3 = [0.45  0.05  0.25  0.25  0.5  5  1]; % parameter group 3
Theta4 = [0.45  0.05  0.25  0.25  0.5  5  1]; % parameter group 4
Theta5 = [0.15  0.10  0.30  0.45  0.5  5  1]; % parameter group 5
```
the core code is:
```matlab
q=ones(1,K);

%%Multiply the probability with weight
for k = 1:K
    
    z_tk = zt(k);

    %%  TODO
    p1 = z_hit * p_hit(z_tk,z_tk_star,sigma_hit,z_MAX);
    p2 = z_short * p_short(z_tk,z_tk_star,lambda_short);
    p3 = z_max * p_max(z_tk,z_MAX);
    p4 = z_rand * p_rand(z_tk,z_MAX);
    q(k)= (p1+p2+p3+p4);
end
```
 The result figure with parameter Theta1 is:

Theta1 = [0.85  0.05  0.05  0.05  0.1  5  1]; % parameter group 1

![Screenshot from 2019-04-15 23-03-18](/home/hya/Pictures/Screenshot from 2019-04-15 23-03-18.png)



Theta2 = [0.50  0.15  0.15  0.20  0.5  5  1]; % parameter group 2

![Screenshot from 2019-04-15 23-03-39](/home/hya/Pictures/Screenshot from 2019-04-15 23-03-39.png)



Theta3 = [0.45  0.05  0.25  0.25  0.5  5  1]; % parameter group 3

![Screenshot from 2019-04-15 23-06-19](/home/hya/Pictures/Screenshot from 2019-04-15 23-06-19.png)



Theta4 = [0.45  0.05  0.25  0.25  0.5  5  1]; % parameter group 4

![Screenshot from 2019-04-15 23-06-32](/home/hya/Pictures/Screenshot from 2019-04-15 23-06-32.png)



Theta5 = [0.15  0.10  0.30  0.45  0.5  5  1]; % parameter group 5

![Screenshot from 2019-04-15 23-06-49](/home/hya/Pictures/Screenshot from 2019-04-15 23-06-49.png)



All codes are in hw6_q1.m.

**Problem 2: Given the following map, please generate scan measurement probability model and the beam measurement probability model.**

I set some point and a obstacle in the sense's scan path.

set initial coondition:

```matlab
x=0;
y=0;
theta=pi/2;
x_sens=0;
y_sens=0;
theta_sens=0;
```
![Screenshot from 2019-04-15 23-32-32](/home/hya/Pictures/Screenshot from 2019-04-15 23-32-32.png)



The  scan measurement probability model result is:

![Screenshot from 2019-04-15 23-32-37](/home/hya/Pictures/Screenshot from 2019-04-15 23-32-37.png)



All the code of this problem is in hw6_q2.m.

**Problem 3: Please generate the following landmark measurement probability model by using 3 ranging sensors.**

The initial position of sensor is:

```matlab
aim = [7 3];
rectangle('Position',pos);
hold on

sensor1 = [0 0];
sensor2 = [5 0];
sensor3 = [5 5];
```

Result of sensor detect is:

![Screenshot from 2019-04-15 23-19-24](/home/hya/Pictures/Screenshot from 2019-04-15 23-19-24.png)

The green point is aim point, purple point is the position sensor predicted.

All code is in hw6_q3.m.