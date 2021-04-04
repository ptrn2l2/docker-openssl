Push-Location -Path $PSScriptRoot
docker build -t ptrn2l2/openssl:ubuntu-20.04 . -f .\ubuntu-20.04_openssl.Dockerfile
Pop-Location
