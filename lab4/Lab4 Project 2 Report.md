# Lab4 Project 2 Report

student: 11610303 黄玉安
partner: 11610313 欧阳奕成

### Goal

 This project is aimed to introduce you the basic operations of TurtleBot2.  Run ROS on a real robot and investigate the sensor functions on that.

### Rosbag play & Screenshot 

We use  `rosbag play -l 2019-03-26-21-17-31.bag`  to play the bag our recorde as a loop. Then echo each topic:

- `rostopic echo /tf`

![tf](/home/hya/Pictures/tf.png)



TF is a package that lets the user keep track of multiple coordinate frames over time. tf maintains the relationship between coordinate frames in a tree structure buffered in time, and lets the user transform points, vectors, etc between any two coordinate frames at any desired point in time.

There are two type's of information. Translation represent the position of robot. Rotation use 4 elements (Quaternion) to represent its orientation.

- `rostopic echo /tf_static`

![tf_static](/home/hya/Pictures/tf_static.png)

For greater efficiency tf now has a static transform topic "/tf_static" This topic has the same format as "/tf" however it is expected that any transform on this topic can be considered true for all time. Internally any query for a static transform will return true.


- `rostopic echo /odom`

![odom](/home/hya/Pictures/odom.png)

The frame attached to the odometry system. The accuracy of dom frame makes it very useful in local reference systems. However, it is not suitable to cooperate with the global reference frame.



We use rqt to view the camera topics

- `rosrun rqt_image_view camera/rgb/image_color`

![color](/home/hya/Pictures/color.png)

It shows images with color.




- `rosrun rqt_image_view camera/depth_registered/image_raw`

![raw](/home/hya/Pictures/raw.png)

It is the raw images. Using RAW format can avoid the loss of image quality compressed to JPEG format.




- `rosrun rqt_image_view camera/rgb/image_mono`

![mono](/home/hya/Pictures/mono.png)

It is image without color (only black and white).