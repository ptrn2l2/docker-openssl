﻿FROM ubuntu:24.04
RUN apt-get update -y && \ 
	apt-get upgrade -y && \
	apt-get install -y openssl openssh-client

ENTRYPOINT ["openssl"]
