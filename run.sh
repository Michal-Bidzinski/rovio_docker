xhost + local:root

docker run --rm -it \
    --name rovio \
	--env="DISPLAY=:1" \
	--env="QT_X11_NO_MITSHM=1" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
	--privileged \
    --network=host \
    --volume="/dev:/dev" \
    --volume "${PWD}/bags:/catkin_ws/bags" \
    iss/rovio:noetic
