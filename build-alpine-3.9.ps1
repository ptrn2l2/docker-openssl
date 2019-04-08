Push-Location -Path $PSScriptRoot
docker build -t ptrn2l2/openssl:alpine-3.9 . -f .\alpine-3.9_openssl.Dockerfile
docker tag ptrn2l2/openssl:alpine-3.9 ptrn2l2/openssl:latest
Pop-Location
