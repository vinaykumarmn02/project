FROM ubuntu:16.04
RUN apt-get update && apt-get install -y openssh-server \
     git \
     openssh-client 
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    touch /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

#COPY  /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

#EXPOSE 22
CMD [ "sh", "-c" , "service ssh start; bash" ]
