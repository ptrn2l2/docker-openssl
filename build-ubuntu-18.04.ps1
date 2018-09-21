Push-Location -Path $PSScriptRoot
docker build -t ptrn2l2/openssl:ubuntu-18.04 . -f .\ubuntu-18.04_openssl.Dockerfile
Pop-Location
