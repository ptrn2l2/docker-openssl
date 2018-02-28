FROM ubuntu:16.04
RUN apt-get update -y && \ 
	apt-get upgrade -y && \
	apt-get install -y openssl

ENTRYPOINT ["openssl"]
