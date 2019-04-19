#include <ros/ros.h>
#include <opencv2/opencv.hpp>
#include <image_transport/image_transport.h>
#include <cv_bridge/cv_bridge.h>

#include <sensor_msgs/Image.h>
#include <std_msgs/Int32MultiArray.h>
#include <object_detect/object_detect_result.h>

#include <message_filters/subscriber.h>
#include <message_filters/synchronizer.h>
#include <message_filters/sync_policies/approximate_time.h>

image_transport::Publisher image_pub_;

void callback(const sensor_msgs::ImageConstPtr& msg_image , const object_detect::object_detect_resultConstPtr& msg_dynamic_obj){
//  ROS_INFO("Hello");
  //std::cout<< "THE header of object_detect_resultConstPtr :" << msg_dynamic_obj->header << std::endl;
  std_msgs::Int32MultiArray dynamic_obj_result;
  dynamic_obj_result = msg_dynamic_obj->result;
  //std::cout<< "THE size of result  :" << dynamic_obj_result.data.size() << std::endl;
  int datalen = 8;
  int objnum = dynamic_obj_result.data.size()/datalen;

  cv_bridge::CvImagePtr cv_ptr;
  try
  {
    cv_ptr = cv_bridge::toCvCopy(msg_image, sensor_msgs::image_encodings::BGR8);
  }
  catch (cv_bridge::Exception& e)
  {
    ROS_ERROR("cv_bridge exception: %s", e.what());
    return;
  }

  if(objnum>0){
//    std::cout<<"objnum is "<<objnum<<std::endl;
//    std::cout<< "THE size of result  :" << dynamic_obj_result << std::endl;
    for(int i = 1; i <=objnum; ++i ){
      int xL = dynamic_obj_result.data[2+(i-1)*datalen];
      int yL = dynamic_obj_result.data[3+(i-1)*datalen];
      int xR = dynamic_obj_result.data[4+(i-1)*datalen];
      int yR = dynamic_obj_result.data[5+(i-1)*datalen];
//      std::cout<<"i is "<<i<<std::endl;
//      std::cout<<"xL is "<<xL<<std::endl;
//      std::cout<<"yL is "<<yL<<std::endl;
//      std::cout<<"xR is "<<xR<<std::endl;
//      std::cout<<"yR is "<<yR<<std::endl;

      cv::rectangle(cv_ptr->image,cvPoint(xL,yL),cvPoint(xR,yR),cv::Scalar(0,0,255),2,2,0);
    }
  }

  image_pub_.publish(cv_ptr->toImageMsg());

}


int main(int argc, char** argv)
{
  std::cout<< "main : 20190411 version" << std::endl;
  ros::init(argc, argv, "plot_camobj_node");

  ros::NodeHandle nh;
  image_transport::ImageTransport it(nh);
  image_pub_ = it.advertise("image_converter/output_video", 1);

  message_filters::Subscriber<sensor_msgs::Image> image_sub(nh, "/image_raw", 3);  // /image_raw
  message_filters::Subscriber<object_detect::object_detect_result> dynamic_obj_sub(nh, "/dynamic_object_detect", 3);

  typedef message_filters::sync_policies::ApproximateTime<sensor_msgs::Image, object_detect::object_detect_result> MySyncPolicy;
  // ApproximateTime takes a queue size as its constructor argument, hence MySyncPolicy(10)
  message_filters::Synchronizer<MySyncPolicy> sync(MySyncPolicy(3), image_sub, dynamic_obj_sub);

  sync.registerCallback(boost::bind(&callback, _1, _2));


  ros::spin();

  return 0;
}
