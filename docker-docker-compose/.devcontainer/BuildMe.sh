version_file="/workspace/.devcontainer/version.py"

echo "version_dict = {\"git_hash\":\"\"\"">$version_file
git rev-parse HEAD >>$version_file
echo "\"\"\",">>$version_file
echo "\"build_time\":\"\"\"">>$version_file
date >>$version_file
echo "\"\"\"">>$version_file
echo "}">>$version_file

CMD="
while [ ! -d '/workspace/' ]; do sleep 10; done &&
cd /workspace/scripts/ && 
pip install -r requirements.txt &&
pyinstaller /workspace/scripts/switchboard.py --onefile --paths /workspace/scripts/ &&
tar -czvf switchboard_centos_6_10.tar -C dist/ . &&
rm -rf build/ dist/"

cp $version_file ../scripts/version.py
if [ $(cat /proc/1/cgroup | grep docker -c) -gt 1 ]; then
    # build in dockerfile
    CONTAINER=$(cat /etc/hostname)
    echo "Building inside container: $CONTAINER";
    docker run --volumes-from $CONTAINER buildbase:latest /bin/bash -c "$CMD"
else
    # build on macbook
    echo "Running not inside docker"
    docker rm build_tmp
    docker run --name build_tmp buildbase:latest
    docker cp build_tmp:/Build/switchboard_centos_6_10.tar ../switchboard_centos_6_10.tar 
    docker rm build_tmp
fi