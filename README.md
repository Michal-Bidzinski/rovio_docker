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
Folder "bags" was prepared as volume to testing algorithm by using rosbags.
