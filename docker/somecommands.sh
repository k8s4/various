docker ps -a | awk '{print $1}' | grep -v CONTAINER | while read -r file; do docker rm $file; done;
docker images | awk '{print $3}' | grep -v "IMAGE ID" | while read -r file; do docker rmi $file; done;
cat /proc/net/fib_trie
