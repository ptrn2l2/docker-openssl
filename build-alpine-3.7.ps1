Push-Location -Path $PSScriptRoot
docker build -t ptrn2l2/openssl:alpine-3.7 . -f .\alpine-3.7_openssl.Dockerfile
Pop-Location
