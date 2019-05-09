1. 初始化

   ```
   //用于启动turtlebot
   roslaunch turtlebot_bringup minimal.launch
   //点云的数据在 /camera/depth/image_raw
   roslaunch openni_launch openni.launch 
   //点云的数据在 /camera/depth_registered/image_raw
   roslaunch　freenect_launch　freenect-registered-xyzrgb.launch
   ```

2.  控制运动

   ```
   roslaunch turtlebot_teleop keyboard_teleop.launch
   ```

3. 开启图像显示

   ```
   //需要bringup. 
   rosrun pokemon pokemon_searching
   ```

4. 自动调整距离

   ```
   //当前版本是使用openni的launch
   rosrun pokemon pokemon_catching
   ```

5. gmmapping（gmapping目前和pokemon_catching不能共存）

   ```
    roslaunch turtlebot_navigation gmapping_demo.launch
    rviz
    //需要选中odom, map, laser
    rosrun map_server map_saver -f pokemon_map
   ```
