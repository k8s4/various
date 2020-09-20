# Test ENTRYPOINT
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y iputils-ping apache2

ENV var1=ping var2=8.8.8.8

# It will be replacing when you use #docker run <command>
CMD [$var1,$var2]
# But it have upper priority
#ENTRYPOINT ["apache2ctl"]
