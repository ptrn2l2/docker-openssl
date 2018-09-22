# docker-openssl

Run OpenSSL commands in docker container, expecially usefull to me under windows.
There is also support for openssh clients, so to use *openssh-keygen* needed to generate public/private keys to passwordless authenticate using ssh.

## Self signed certificate example

Use ${PWD} in PowerShell, $(pwd) in bash, %cd% in cmd.exe:

~~~~bash
docker run --name gen-ssl-key-cert-pair --rm -it -v $(pwd):/wrk ptrn2l2/openssl:alpine-3.8 req -x509 -days 3650 -newkey rsa:2048 -subj "/C=IT/ST=CE/L=CE/O=IT/OU=ITDept/CN=example.com" -nodes -keyout /wrk/selfsigned.key -out /wrk/selfsigned.crt
~~~~

where

* /C=XX // Country Code
* /ST=State // State Name
* /L=City // Location (City name)
* /O=Information Technology // Organization Name
* /OU=ITDept // Organizational Unit
* /CN=example.com // Common Name

## Diffie-Hellman Parameters Generation Example

Use ${PWD} in PowerShell, $(pwd) in bash, %cd% in cmd.exe:

~~~~bash
docker run --name gen-dhparam --rm -it -v $(pwd):/wrk ptrn2l2/openssl:alpine-3.8 dhparam -out /wrk/dhparam.pem 2048
~~~~
