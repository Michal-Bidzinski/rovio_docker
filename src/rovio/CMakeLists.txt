cmake_minimum_required (VERSION 3.5)
project(rovio)
# # Default to C99
# if(NOT CMAKE_C_STANDARD)
#   set(CMAKE_C_STANDARD 99)
# endif()

# # Default to C++14
# if(NOT CMAKE_CXX_STANDARD)
#   set(CMAKE_CXX_STANDARD 14)
# endif()

# if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
#   add_compile_options(-Wall -Wextra -Wpedantic)
# endif()

set(CMAKE_CXX_STANDARD 14)

set(ROVIO_NMAXFEATURE 25 CACHE STRING "Number of features for ROVIO")
set(ROVIO_NCAM 1 CACHE STRING "Number of enabled cameras")
set(ROVIO_NLEVELS 4 CACHE STRING "Number of image leavels for the features")
set(ROVIO_PATCHSIZE 6 CACHE STRING "Size of patch (edge length in pixel)")
set(ROVIO_NPOSE 0 CACHE STRING "Additional estimated poses for external pose measurements")

##################### Find, include, and compile library #####################
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
add_definitions(-DROVIO_NMAXFEATURE=${ROVIO_NMAXFEATURE})
add_definitions(-DROVIO_NCAM=${ROVIO_NCAM})
add_definitions(-DROVIO_NLEVELS=${ROVIO_NLEVELS})
add_definitions(-DROVIO_PATCHSIZE=${ROVIO_PATCHSIZE})
add_definitions(-DROVIO_NPOSE=${ROVIO_NPOSE})

include_directories(${EIGEN3_INCLUDE_DIR})


# add_subdirectory(lightweight_filtering)
##################### Install ROS stuff #####################

find_package(rosidl_default_generators REQUIRED)
find_package(ament_cmake REQUIRED)
find_package(lightweight_filtering REQUIRED)
find_package(kindr REQUIRED)
find_package(rclcpp REQUIRED)
# find_package(roslib REQUIRED)
find_package(cv_bridge REQUIRED)
find_package(nav_msgs REQUIRED)
find_package(geometry_msgs REQUIRED)
find_package(visualization_msgs REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(std_msgs REQUIRED)
find_package(tf2_ros REQUIRED)
find_package(std_srvs REQUIRED)
# find_package(rosbag REQUIRED)
find_package(Eigen3 REQUIRED)

find_package(OpenCV REQUIRED COMPONENTS core highgui imgproc features2d)

find_package(PkgConfig)

find_package(yaml_cpp_catkin QUIET)

# rosidl_generate_interfaces(
#     ${PROJECT_NAME}
#         srv/SrvResetToPose.srv
#     DEPENDENCIES
#         std_msgs
#         geometry_msgs
# )
rosidl_generate_interfaces(${PROJECT_NAME}
  "srv/SrvResetToPose.srv"
  DEPENDENCIES
  	std_msgs
  	geometry_msgs
)

include_directories(include ${YamlCpp_INCLUDE_DIRS} lightweight_filtering)
# set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lightweight_filtering")

# ament_target_dependencies(${PROJECT_NAME} ${YamlCpp_LIBRARIES} ${OpenMP_EXE_LINKER_FLAGS} ${OPENGL_LIBRARIES} ${GLUT_LIBRARY} ${GLEW_LIBRARY} ${OpenCV_LIBRARIES} "cv_bridge" "tf2_ros" "visualization_msgs" "std_srvs" "rclcpp" "sensor_msgs" "nav_msgs" "kindr" "geometry_msgs")
# ament_target_dependencies(${PROJECT_NAME} lightweight_filtering)
add_executable(rovio_node 
	src/rovio_node.cpp)
add_dependencies(rovio_node ${PROJECT_NAME})

# foreach(typesupport_impl ${typesupport_impls})
rosidl_target_interfaces(rovio_node
  ${PROJECT_NAME} "rosidl_typesupport_cpp")

ament_target_dependencies(rovio_node 
	rclcpp 
	geometry_msgs 
	lightweight_filtering 
	Eigen3 
	kindr 
	cv_bridge 
	tf2_ros 
	visualization_msgs 
	sensor_msgs 
	nav_msgs
	std_srvs)

# add_executable(rovio_rosbag_loader src/rovio_rosbag_loader.cpp)
# ament_target_dependencies(rovio_rosbag_loader)

ament_export_include_directories(include ${catkin_INCLUDE_DIRS})
ament_export_libraries(${PROJECT_NAME})
ament_export_dependencies(lightweight_filtering kindr rclcpp  cv_bridge message_runtime nav_msgs geometry_msgs sensor_msgs std_msgs tf2_ros yaml_cpp_catkin)
ament_package()


if(0)
	find_package(OpenMP REQUIRED)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
endif()

if(MAKE_SCENE)
	find_package(GLEW REQUIRED)

	find_package(GLUT REQUIRED)

	find_package(OpenGL REQUIRED)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DMAKE_SCENE=1")
	add_definitions(${GLUT_DEFINITIONS})
	add_definitions(${OpenGL_DEFINITIONS})
	include_directories(${GLEW_INCLUDE_DIRS})
	include_directories(${GLUT_INCLUDE_DIRS})
	include_directories(${OpenGL_INCLUDE_DIRS})
	message(STATUS "Building ROVIO with openGL Scene Visualization")
	link_directories(${GLUT_LIBRARY_DIRS})
	link_directories(${OpenGL_LIBRARY_DIRS})
endif()
if(${yaml_cpp_catkin_FOUND})
  pkg_check_modules(YamlCpp REQUIRED yaml-cpp>=0.5)
  set(YamlCpp_LIBRARIES ${yaml_cpp_catkin_LIBRARIES})
  set(YamlCpp_INCLUDE_DIRS ${yaml_cpp_catkin_INCLUDE_DIRS})
  message(STATUS "Found yaml_cpp_catkin, using instead of system library.")
else()
  message(STATUS "No yaml_cpp_catkin, using yaml-cpp system library instead.")
endif()

if(MAKE_SCENE)
	add_library(${PROJECT_NAME} src/Camera.cpp src/FeatureCoordinates.cpp src/FeatureDistance.cpp src/Scene.cpp)
	add_library(${PROJECT_NAME} src/Camera.cpp src/FeatureCoordinates.cpp src/FeatureDistance.cpp)
else()
endif()

#add_executable(feature_tracker_node src/feature_tracker_node.cpp)
#target_link_libraries(feature_tracker_node ${PROJECT_NAME})
#add_dependencies(feature_tracker_node ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/gtest/")
	include_directories(${gtest_SOURCE_DIR}/include ${gtest_SOURCE_DIR})
	add_executable(test_patch src/test_patch.cpp src/Camera.cpp src/FeatureCoordinates.cpp src/FeatureDistance.cpp)
	target_link_libraries(test_patch gtest_main gtest pthread ${catkin_LIBRARIES} ${YamlCpp_LIBRARIES})
	add_executable(test_mlp src/test_mlp.cpp src/Camera.cpp src/FeatureCoordinates.cpp src/FeatureDistance.cpp)
	target_link_libraries(test_mlp gtest_main gtest pthread ${catkin_LIBRARIES} ${YamlCpp_LIBRARIES})
	message(STATUS "Building GTests!")
	option(BUILD_GTEST "build gtest" ON)
	#add_subdirectory(gtest gtest)
	enable_testing()
	add_test(test_patch test_patch)
	add_test(test_mlp test_mlp)
endif()
