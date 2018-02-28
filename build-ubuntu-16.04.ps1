Push-Location -Path $PSScriptRoot
docker build -t ptrn2l2/openssl:ubuntu-16.04 . -f .\ubuntu-16.04_openssl.Dockerfile
Pop-Location
