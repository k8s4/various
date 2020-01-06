# Test for networking module
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y iputils-ping traceroute
EXPOSE 80
ENTRYPOINT ["ping"]
CMD ["8.8.8.8"]
