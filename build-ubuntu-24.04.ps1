Push-Location -Path $PSScriptRoot
docker build -t ptrn2l2/openssl:ubuntu-24.04 . -f .\ubuntu-24.04_openssl.Dockerfile
Pop-Location
