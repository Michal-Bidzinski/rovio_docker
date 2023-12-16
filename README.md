# rovio_docker

Build the docker image by executing:
```
cd .devcontainer
bash build.sh
```
Run the docker container:
```
cd ..
bash run.sh
```
In container:
```
roslaunch rovio rovio_node.launch
```
Folder "bags" was prepared as volume to testing algorithm by using rosbags. In second terminal:
```
bash enter.sh
rosbag play catkin_ws/bags/bagname.bag 
```

# Raspberry Pi
To build image to run on raspberry pi, use command:
```
docker buildx build --load -t iss/rovio:noetic  --platform linux/arm64  .
```
Then you can save image:
```
docker save -o iss_rovio_noetic_arm.tar iss/rovio:noetic
```
unpack on raspberry pi:
```
docker load -i iss_rovio_noetic_arm.tar
```
and run it.
