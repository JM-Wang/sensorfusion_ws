cmake_minimum_required(VERSION 2.8.3)
project(object_detect)

## Compile as C++11, supported in ROS Kinetic and newer
add_compile_options(-std=c++11)

find_package(OpenCV REQUIRED )

find_package(catkin REQUIRED COMPONENTS
  roscpp
  rospy
  std_msgs
  cv_bridge
  image_transport
  message_generation
)

add_message_files(
  FILES
  object_detect_result.msg
)

generate_messages(
  DEPENDENCIES
  std_msgs
)

catkin_package(
  CATKIN_DEPENDS message_runtime
)

include_directories(
  include
  ${catkin_INCLUDE_DIRS}
)




##************************[plot_camobj]*****************************

add_executable(plot_camobj plot_camobj/plot_camobj.cpp)
target_link_libraries(plot_camobj
    ${catkin_LIBRARIES}
)



