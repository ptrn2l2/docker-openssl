# docker-openssl

Run OpenSSL commands in docker container, expecially usefull to me under windows.
There is also support for openssh clients, so to use *openssh-keygen* needed to generate public/private keys to passwordless authenticate using ssh.

## Verify folder sharing

Sometimes using Docker in linux mode under windows, even tough the drives are shared in Docker for desktop's options, file sharing silently fails, so I always verify that is working.

Open a powershell, issue a *"dir"* commad and verify that exists at least one file in current folder, so that we can verify file sharing.
Then issue the following command:

~~~~powershell
docker run --name tmp_ls --rm -it --entrypoint="/bin/ls" -v ${PWD}:/wrk ptrn2l2/openssl /wrk
~~~~

Verify that the same files are listed comparing the output of preceiding docker's *"ls"* and powershell's *"dir"* commands.

If it fails issue the following command in an **Administrator's Powershell** console (refs: [stackoverflow](<https://stackoverflow.com/a/43904051>), [blog.olandese.nl](<https://blog.olandese.nl/2017/05/03/solve-docker-for-windows-error-a-firewall-is-blocking-file-sharing-between-windows-and-the-containers/>)):

~~~~powershell
Set-NetConnectionProfile -interfacealias "vEthernet (DockerNAT)" -NetworkCategory Private
~~~~

and retry. If it fails see ["stevelasker" blog](https://blogs.msdn.microsoft.com/stevelasker/2016/06/14/configuring-docker-for-windows-volumes/). If it fails try to solve the problem and retry.

## Self signed certificate example

> Use ${PWD} in PowerShell, $(pwd) in bash, %cd% in cmd.exe

Generate a self signed cert for "example.com" domain that lasts for ~1 year (NOTE: for wildcard you'll need configuration files)

~~~~powershell
docker run --name gen-ssl-key-cert-pair --rm -it -v ${PWD}:/wrk ptrn2l2/openssl req -new -x509 -days 365 -newkey rsa:4096 -subj "/C=IT/ST=CE/L=CE/O=IT/OU=ITDept/CN=example.com" -nodes -keyout /wrk/selfsigned.key -out /wrk/selfsigned.crt
~~~~

where

* /C=XX // Country Code
* /ST=State // State Name
* /L=City // Location (City name)
* /O=Information Technology // Organization Name
* /OU=ITDept // Organizational Unit
* /CN=example.com // Common Name

## Diffie-Hellman Parameters Generation Example

> Use ${PWD} in PowerShell, $(pwd) in bash, %cd% in cmd.exe:

~~~~powershell
docker run --name gen-dhparam --rm -it -v ${PWD}:/wrk ptrn2l2/openssl dhparam -out /wrk/dhparam.pem 2048
~~~~

## ssh private/public pair

Generate *ssh* keys useful for passwordless authentication in *&lt;current folder&gt;/ssh_keys*:

~~~~powershell
docker run --name gen_ssh_fold --rm -it --entrypoint="mkdir" -v ${pwd}:/wrk ptrn2l2/openssl -p /wrk/ssh_keys
docker run --name gen_ssh_pkey --rm -it --entrypoint="ssh-keygen" -v ${pwd}:/wrk ptrn2l2/openssl -t rsa -b 4096 -f /wrk/ssh_keys/id_rsa
docker run --name tmp_ls_wrk --rm -it --entrypoint="/bin/ls" -v ${pwd}:/wrk ptrn2l2/openssl /wrk/ssh_keys
~~~~

Password can be ignored (just typing a return) for passwordless login.

Copy public key to a remote server using ssh client libraries, change *user* with real user name and *example&#46;com* with real domain

~~~~powershell
docker run --name gen_ssh_cp --rm -it --entrypoint="ssh-copy-id" -v ${pwd}:/wrk ptrn2l2/openssl "user@example.com -p 22 -f /wrk/ssh_keys/id_rsa.pub"
~~~~

> ### NOTE: public key can be manually copied without using *ssh-copy-id*
> This is a nice example of copying without open-ssh client commands (found in [askubuntu](<https://askubuntu.com/a/6186>) by "Huygens"):
>
>> *# cat "/wrk/ssh_keys/id_rsa.pub | ssh user@example.com 'umask 0077; mkdir -p .ssh; cat >> .ssh/authorized_keys && echo "Key copied"'*

Password can be changed (or added if it was not setted), but it cannot be easly done using one docker command, at least in windows, because of permission problems on generated files.
Here I show the "easy" way

First open an interactive shell:

~~~~powershell
docker run --name tmp_sh --rm -it --entrypoint="/bin/sh" -v ${pwd}:/wrk ptrn2l2/openssl
~~~~

The inside the docker container execute:

~~~~sh
cp /wrk/ssh_keys/id_rsa /root/.
ls /root
chmod 600 /root/id_rsa
ls /root
ssh-keygen -f /root/id_rsa -p
ls /wrk/ssh_keys
cp -f /root/id_rsa /wrk/ssh_keys/.
ls /wrk/ssh_keys
logout
~~~~
