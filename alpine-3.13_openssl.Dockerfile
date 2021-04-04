FROM alpine:3.13

RUN apk update && \
  apk add --no-cache openssl openssh-keygen openssh-client bash && \
  rm -rf /var/cache/apk/*

ENTRYPOINT ["openssl"]