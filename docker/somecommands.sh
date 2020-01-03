docker ps -a | awk '{print $1}' | grep -v CONTAINER | while read -r file; do docker rm $file; done;
