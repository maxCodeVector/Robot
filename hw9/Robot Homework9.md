# Robot Homework9
11610303 黄玉安

#### Problem 1: estimate the Gaussian probabilistic distributions of the four landmarks given the robot position, [x, y],and the range measurements of [r1, r2, r3, r4].

Use triangle area formula `S = sqrt( p(p-a)(p-b)(p-c) )` to calculate 4 triangle's area, and use 

`fsolve` to solve the equation, which a is the variable that we want to solve, by doing this way, we can know a, so the landmark's position is easy to calculate.  

The red circle is landmark's real position, blue one is calculated result.

![p1]( /src/p1.png)





#### Problem 2: generate occupancy and ML grid maps (by using the threshold of 0.5)

![m](/home/hya/Documents/Robot/hw9/src/m.png)



The occupancy and ML grid map is showing above. We can see that it has some shadow.

![o1](/home/hya/Documents/Robot/hw9/src/o1.png)





![o2](/home/hya/Documents/Robot/hw9/src/o2.png)



#### Problem 3: generate the reflection map



The reflection maps is showing above. We can see that its shadow is few compared to 

occupancy map.

![r1](/home/hya/Documents/Robot/hw9/src/r1.png)





![r2](/home/hya/Documents/Robot/hw9/src/r2.png)

![r3](/home/hya/Documents/Robot/hw9/src/r3.png)