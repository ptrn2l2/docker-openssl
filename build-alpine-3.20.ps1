Push-Location -Path $PSScriptRoot
docker build -t ptrn2l2/openssl:alpine-3.20 . -f .\alpine-3.20_openssl.Dockerfile
docker tag ptrn2l2/openssl:alpine-3.20 ptrn2l2/openssl:latest
Pop-Location
