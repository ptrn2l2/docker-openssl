# docker-openssl

Run OpenSSL commands in docker container, expecially usefull to me under windows.
There is also support for openssh clients, so to use *openssh-keygen* needed to generate public/private keys to passwordless authenticate using ssh.

## Verify folder sharing

Sometimes using Docker in linux mode under windows, even tough the drives are shared in Docker for desktop's options, file sharing silently fails, so I always verify that is working.

Open a powershell, issue a *"dir"* commad and verify that exists at least one file in current folder, so that we can verify file sharing.
Then issue the following command in PowerShell:

~~~~powershell
docker run --name tmp_ls --rm -it --entrypoint="/bin/ls" -v ${PWD}:/wrk ptrn2l2/openssl /wrk
~~~~

Verify that the same files are listed comparing the output of preceiding docker's *"ls"* and powershell's *"dir"* commands.

If it fails issue the following command in an **Administrator's Powershell** console (refs: [stackoverflow](<https://stackoverflow.com/a/43904051>), [blog.olandese.nl](<https://blog.olandese.nl/2017/05/03/solve-docker-for-windows-error-a-firewall-is-blocking-file-sharing-between-windows-and-the-containers/>)):

~~~~powershell
Set-NetConnectionProfile -interfacealias "vEthernet (DockerNAT)" -NetworkCategory Private
~~~~

and retry. If it fails see ["Configuring Docker for Windows Shared Drives / Volume Mounting with AD"](https://docs.microsoft.com/it-it/archive/blogs/stevelasker/configuring-docker-for-windows-volumes). If it fails try to solve the problem and retry.

## Self signed certificate example

> Use ${PWD} in PowerShell, $(pwd) in bash, %cd% in cmd.exe

Generate a self signed cert for "example.com" domain that lasts for ~1 year (NOTE: to use wildcard in /CN you'll need configuration files)

~~~~powershell
docker run --name gen-ssl-key-cert-pair --rm -it -v ${PWD}:/wrk ptrn2l2/openssl \
    req -new -x509 -days 365 -newkey rsa:4096 -nodes -keyout /wrk/selfsigned.key \
    -out /wrk/selfsigned. crt \
    -subj "/C=IT/ST=Campania/L=Caserta/O=Localhost Co/OU=I.T.Dept/emailAddress=email@example.com/CN=www.localhost" \
    -addext "subjectAltName=DNS:*.localhost,DNS:localhost"
~~~~

where

* /C is Country Code
* /ST is State Name
* /L is Location (City name)
* /O is Organization Name
* /OU is Organizational Unit
* /CN is Common Name - used for SNI (Server Name Indication)

In real scenarios, if your domain is "example.com", use

* CN=www.example.com
* "subjectAltName=DNS:*.example.com,DNS:example.com"

## Diffie-Hellman Parameters Generation Example

> Use ${PWD} in PowerShell, $(pwd) in bash, %cd% in cmd.exe:

~~~~powershell
docker run --name gen-dhparam --rm -it -v ${PWD}:/wrk ptrn2l2/openssl dhparam -out /wrk/dhparam.pem 2048
~~~~

## ssh private/public pair

Generate *ssh* keys in *&lt;current folder&gt;/ssh_keys*,  useful for passwordless ssh authentication (to change key name use -f /wrk/ssh_keys/<NAME>, I would alway prefix it with "id_rsa_"):

~~~~powershell
docker run --name gen_ssh_fold --rm -it --entrypoint="mkdir" -v ${pwd}:/wrk ptrn2l2/openssl -p /wrk/ssh_keys
docker run --name gen_ssh_pkey --rm -it --entrypoint="ssh-keygen" -v ${pwd}:/wrk ptrn2l2/openssl -t rsa -b 4096 -f /wrk/ssh_keys/id_rsa
docker run --name tmp_ls_wrk --rm -it --entrypoint="/bin/ls" -v ${pwd}:/wrk ptrn2l2/openssl /wrk/ssh_keys
~~~~

Password can be ignored (just typing a return) for passwordless login, and can later be added or removed, as showed later here.

Copy public key to a remote server using ssh client libraries, change *user* with server user name and *example&#46;com* with server URI

~~~~powershell
docker run --name gen_ssh_cp --rm -it --entrypoint="ssh-copy-id" -v ${pwd}:/wrk ptrn2l2/openssl "-p 22 -f -i /wrk/ssh_keys/id_rsa.pub user@example.com"
~~~~

> ### NOTE: public key can be manually copied without using *ssh-copy-id*
> This is a nice example of copying without open-ssh client commands (found in [askubuntu](<https://askubuntu.com/a/6186>) by "Huygens"):
>
>> *# cat "/wrk/ssh_keys/id_rsa.pub | ssh user@example.com 'umask 0077; mkdir -p .ssh; cat >> .ssh/authorized_keys && echo "Key copied"'*

Password can be changed (or added), but it cannot be easly done using one docker command, at least in windows, because of permission problems on generated files.
Here I show the "easy" way

First open an interactive shell:

~~~~powershell
docker run --name tmp_sh --rm -it --entrypoint="/bin/sh" -v ${pwd}:/wrk ptrn2l2/openssl
~~~~

Then inside the docker container execute (I copy the pub key too just to show file permissions - all files should be 644 (pub keys, authorized_keys, known_hosts, configuration), but private keys should be 600):

~~~~sh
mkdir -p /root/.ssh
chmod 700 /root/.ssh
cp /wrk/ssh_keys/id_rsa /root/.ssh/.
# cp /wrk/ssh_keys/id_rsa.pub /root/.ssh/.
ls /root/.ssh
chmod 600 /root/id_rsa
# chmod 644 /root/id_rsa.pub
ls /root
ssh-keygen -f /root/id_rsa -p
ls /wrk/ssh_keys
cp -f /root/.ssh/id_rsa /wrk/ssh_keys/.
ls /wrk/ssh_keys
logout
~~~~
