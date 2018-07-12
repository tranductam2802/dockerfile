# The demonstration of the docker file configurations.
This repository's the demonstatation of the docker file configurations. This source supported creating a new docker environment, starting-up and connecting via ssh. That also support checking docker problem by http method (This feature will be update late)

### Branch
Pickup branch demo for full update.

### Project structure

    $ la
    total 72
    drwxr-xr-x@ 13 rikimaru  radiant   442 Jul 12 12:48 ./
    drwxr-xr-x   9 rikimaru  radiant   306 Jul 12 11:36 ../
    -rw-r--r--@  1 rikimaru  radiant   185 Jun  4 15:41 config.local.sh
    -rw-r--r--@  1 rikimaru  radiant   623 Jul 12 12:59 config.sh
    drwxr-xr-x@ 12 rikimaru  radiant   408 Jul 12 11:50 docker-setup/
    -rwxr-xr-x@  1 rikimaru  radiant   752 Apr 24 17:33 docker_build.sh*
    -rwxr-xr-x@  1 rikimaru  radiant   208 Jul 12 11:49 docker_connect.sh*
    -rwxr-xr-x@  1 rikimaru  radiant   570 Apr 25 17:50 docker_run.sh*
    drwxr-xr-x   4 rikimaru  radiant   136 Jun  5 10:17 share/

- `config.local.sh`: The configuration file which should not push on Git (proxy config with password etc..)
- `config.sh`: The default configuration.
- `docker_build.sh`: Build the docker environment for first times.
- `docker_run.sh`: Start the docker environment and keep it running.
- `docker_connect.sh`: Connect to the docker environment via ssh.
- `docker-setup/`: Environment settings.

### Build the docker environment for first times
Search `your` keyworld in whole project and update this information as you like. After that, run the `docker_build.sh` for start building.

    $ sh docker_build.sh
    Generating public/private rsa key pair.
    Your identification has been saved in /Users/rikimaru/workspace/docker-demo/docker-setup/ssh_key.
    Your public key has been saved in /Users/rikimaru/workspace/docker-demo/docker-setup/ssh_key.pub.
    The key fingerprint is:
    SHA256:v3UrRIc3*/5654+Cnhdn9t4RwmOPd80kjhsljHLuDsQFVzA rikimaru@cristal_maiden.local
    The key's randomart image is:
    +---[RSA 2048]----+
    |         ..Eo+   |
    |        . * = .  |
    |         + . +   |
    |        . * = .  |
    |      o S+ B *. .|
    |        o.*.X.+o |
    |       . +oBo+.o.|
    |        +.=o=.o+o|
    |        *o.  ..=o|
    +----[SHA256]-----+
    Sending build context to Docker daemon  40.45kB
    Step 1/99 : FROM ubuntu:16.04
     ---> 0b1ed0kjsu27
    ...

### Start the docker environment and keep it running

    $ sh docker_run.sh

### Connect to the docker environment via ssh

    $ sh docker_connect.sh

### Reference
*Note: If you want to create multiple docker container (for stress test, maybe), please refrence to `docker-compose.template.bak` file*
