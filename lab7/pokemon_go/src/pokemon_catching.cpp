#include <ros/ros.h>
#include <image_transport/image_transport.h>
#include <cv_bridge/cv_bridge.h>
#include <sensor_msgs/image_encodings.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <geometry_msgs/Twist.h>
#include <sys/time.h>


using namespace std;
using namespace cv;

// static const std::string OPENCV_WINDOW = "Pokemon Search";
namespace enc = sensor_msgs::image_encodings;
ros::Publisher pub_;
geometry_msgs::Twist cmdvel_;


void image_socket(Mat inImg);
static int imgWidth=640, imgHeight=480;
 


// save a img, the @para inImg is get by cv_ptr -> image, 
// and we can press key P to save it 
void image_socket(const sensor_msgs::ImageConstPtr& msg)
{
    Mat image;

    cv_bridge::CvImagePtr cv_ptr;
    try
    {
      cv_ptr = cv_bridge::toCvCopy(msg, enc::BGR8);
    }
    catch (cv_bridge::Exception& e)
    {
      ROS_ERROR("cv_bridge exception: %s", e.what());
      return;
    }

    image = cv_ptr->image;

    if( image.empty() )
    {
      ROS_INFO("Camera image empty");
      return;
    }
    stringstream sss;    
    string strs;
    static int image_num = 1;
    ROS_INFO("Camera image empty%d : %d", imgHeight, imgWidth);


    strs="/home/instein/catkin_ws/pokemon";
    sss.clear();    
    sss<<strs;    
    sss<<image_num; 

    struct timeval tv;
    gettimeofday(&tv,NULL);
    sss<<tv.tv_sec;
    sss<<".jpg";    
    sss>>strs;    
    imwrite(strs,image);//保存图片

    ROS_INFO("save suceess!\n");
    exit(0);

}



void runRobot(int i){
    if(i==1){
        cmdvel_.linear.x = 0.07;
    }else{
        cmdvel_.linear.x = -0.04;
    }
    cmdvel_.angular.z = 0.0;
    ROS_INFO("linear: %f", cmdvel_.linear.x);
    pub_.publish(cmdvel_);
    ROS_INFO("linear: %f", cmdvel_.linear.x);
}                  

void imageCallback(const sensor_msgs::ImageConstPtr& msg) {

    cv_bridge::CvImagePtr cv_ptr;
    try
    {
      cv_ptr = cv_bridge::toCvCopy(msg, enc::TYPE_16UC1);
    }
    catch (cv_bridge::Exception& e)
    {
      ROS_ERROR("cv_bridge exception: %s", e.what());
      return;
    }

    int depth = cv_ptr->image.at<short int>(cv::Point(240,320));
    if(depth>580){
        runRobot(1);
    }else if(depth<500){
        runRobot(-1);
    }else{
        ROS_INFO("save");
        ros::NodeHandle n;
        image_transport::ImageTransport it(n);
        image_transport::Subscriber saveInfoSub = it.subscribe("/pokemon_go/searcher", 1, image_socket);
        ros::spin();
    }
    ROS_INFO("Depth: %d", depth);
    // runRobot();
}

int main(int argc, char** argv)
{
    ros::init(argc, argv, "pokemon_catching");
    ros::NodeHandle n;
    pub_ = n.advertise<geometry_msgs::Twist>("/cmd_vel_mux/input/teleop", 1);
    image_transport::ImageTransport it(n);
    image_transport::Subscriber sub = it.subscribe("/camera/depth/image_raw", 1, imageCallback);

    
    // runRobot(1);
    ROS_INFO("HELLO");
    ros::spin();
    return 0;
}
