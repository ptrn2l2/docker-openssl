Push-Location -Path $PSScriptRoot
docker build -t ptrn2l2/openssl:alpine-3.13 . -f .\alpine-3.13_openssl.Dockerfile
docker tag ptrn2l2/openssl:alpine-3.13 ptrn2l2/openssl:latest
Pop-Location
