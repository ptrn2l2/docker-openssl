Push-Location -Path $PSScriptRoot
docker build -t ptrn2l2/openssl:alpine-3.8 . -f .\alpine-3.8_openssl.Dockerfile
Pop-Location
