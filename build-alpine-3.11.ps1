Push-Location -Path $PSScriptRoot
docker build -t ptrn2l2/openssl:alpine-3.11 . -f .\alpine-3.11_openssl.Dockerfile
docker tag ptrn2l2/openssl:alpine-3.11 ptrn2l2/openssl:latest
Pop-Location
