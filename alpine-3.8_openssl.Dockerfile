FROM alpine:3.8

RUN apk update && \
  apk add --no-cache openssl && \
  rm -rf /var/cache/apk/*

ENTRYPOINT ["openssl"]
