FROM alpine:3.9

RUN apk update && \
  apk add --no-cache openssl openssh-keygen openssh-client && \
  rm -rf /var/cache/apk/*

ENTRYPOINT ["openssl"]
