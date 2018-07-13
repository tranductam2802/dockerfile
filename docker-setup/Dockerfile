
###### BEGINNING | 初めて ######
# Define the default image template
FROM ubuntu:16.04
MAINTAINER trantap <tranductam2802@gmail.com>

###### VARIABLES | 変数 ######
# Proxy
ARG HTTP_PROXY=""
ARG HTTPS_PROXY=""
ENV http_proxy=${HTTP_PROXY}
ENV https_proxy=${HTTPS_PROXY}

# User
ARG CONTAINER_USER_NAME=demo_username
ARG CONTAINER_PASSWORD=demo_password

# UID/GID
ARG CONTAINER_UID=1001
ARG CONTAINER_GID=1001

# Timezone
ARG TZ=""

###### ENVERONMENT SETTINGS | 環境設定 ######
# Add user
RUN useradd -m -s /bin/bash -u ${CONTAINER_UID} -g ${CONTAINER_GID} ${CONTAINER_USER_NAME}
RUN usermod -aG sudo ${CONTAINER_USER_NAME}

# Update the password
RUN echo "${CONTAINER_USER_NAME}:${CONTAINER_PASSWORD}" | chpasswd

# Run the update and needed tools for this image (ssh, vsftpd, basic utils and libraries)
RUN apt-get update
RUN apt-get install -y sudo ssh vsftpd vim git curl wget build-essential gcc tig byobu nkf libffi-dev libgdal-dev libspatialindex-dev graphviz language-pack-ja supervisor tzdata

# Update the timezone
ENV TZ ${TZ}
RUN sudo rm /etc/timezone
RUN sudo echo ${TZ} > /etc/timezone
RUN sudo rm /etc/localtime
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime
RUN sudo dpkg-reconfigure -f noninteractive tzdata

# Setting environment language
ENV LANG ja_JP.UTF-8
RUN update-locale LANG=ja_JP.UTF-8  # Depend on language-pack-ja

# Permission setting
COPY sudoers /etc/
USER ${CONTAINER_USER_NAME}
WORKDIR /home/${CONTAINER_USER_NAME}


###### ANACONDA PREPARE | anaconda環境の準備 ######
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
RUN ~/.pyenv/bin/pyenv install anaconda2-5.2.0
RUN ln -s ~/.pyenv/versions/anaconda2-5.2.0 ~/anaconda

# PyEnv
RUN echo 'export PATH="/home/'${CONTAINER_USER_NAME}'/.pyenv/bin:$PATH"' >> /home/${CONTAINER_USER_NAME}/.bashrc
RUN echo 'eval "$(pyenv init -)"' >> /home/${CONTAINER_USER_NAME}/.bashrc
RUN echo 'eval "$(pyenv virtualenv-init -)"' >> /home/${CONTAINER_USER_NAME}/.bashrc


###### PYTHON PACKAGE PREPARE | pythonパッケージの準備 ######
RUN mkdir -p /home/${CONTAINER_USER_NAME}/si1_data
COPY requirements.txt /home/${CONTAINER_USER_NAME}/
RUN ~/anaconda/bin/pip install --upgrade pip
RUN ~/anaconda/bin/pip install --upgrade cffi
RUN ~/anaconda/bin/pip install -r /home/${CONTAINER_USER_NAME}/requirements.txt
RUN ~/.pyenv/bin/pyenv global anaconda2-5.2.0

# Install your needed package
RUN ~/.pyenv/shims/conda install ipyparallel traitlets==4.3.2
RUN ~/anaconda/bin/pip install PyJWT
RUN rm /home/${CONTAINER_USER_NAME}/requirements.txt
RUN ~/anaconda/bin/pip list


###### USER ENVIRONMENT PREPARE | ユーザ環境の準備 ######
RUN echo "umask 022" >> /home/${CONTAINER_USER_NAME}/.bashrc

# Proxy
RUN echo "export http_proxy=${http_proxy}" >> /home/${CONTAINER_USER_NAME}/.bashrc
RUN echo "export https_proxy=${https_proxy}" >> /home/${CONTAINER_USER_NAME}/.bashrc
RUN echo "export HTTP_PROXY=${http_proxy}" >> /home/${CONTAINER_USER_NAME}/.bashrc
RUN echo "export HTTPS_PROXY=${https_proxy}" >> /home/${CONTAINER_USER_NAME}/.bashrc
RUN echo "export no_proxy=localhost,127.0.0.1" >> /home/${CONTAINER_USER_NAME}/.bashrc
RUN echo "export NO_PROXY=localhost,127.0.0.1" >> /home/${CONTAINER_USER_NAME}/.bashrc

# Git
RUN sudo mkdir -p /usr/local/git/contrib/completion
RUN wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
RUN wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
RUN sudo mv git-prompt.sh /usr/local/git/contrib/completion
RUN sudo mv git-completion.bash /usr/local/git/contrib/completion
RUN sudo chown root:root /usr/local/git/contrib/completion/git-prompt.sh
RUN sudo chown root:root /usr/local/git/contrib/completion/git-completion.bash
RUN echo "GIT_PS1_SHOWUPSTREAM=true" >> /home/${CONTAINER_USER_NAME}/.bashrc
RUN echo "GIT_PS1_SHOWUNTRACKEDFILES=true" >> /home/${CONTAINER_USER_NAME}/.bashrc
RUN echo "GIT_PS1_SHOWSTASHSTATE=true" >> /home/${CONTAINER_USER_NAME}/.bashrc
RUN echo "GIT_PS1_SHOWDIRTYSTATE=auto" >> /home/${CONTAINER_USER_NAME}/.bashrc
RUN echo "source /usr/local/git/contrib/completion/git-prompt.sh" >> /home/${CONTAINER_USER_NAME}/.bashrc
RUN echo "source /usr/local/git/contrib/completion/git-completion.bash" >> /home/${CONTAINER_USER_NAME}/.bashrc
RUN echo "export PS1='\[\e[32m\]\u\[\e[0m\]@\[\e[33m\]\h\[\e[0m\]:\[\e[36m\]\w\[\e[33m\]\$(__git_ps1 \"[%s]\")\[\e[35m\]\$\[\e[0m\] '" >> /home/${CONTAINER_USER_NAME}/.bashrc
RUN git config --global user.name ${CONTAINER_USER_NAME}
RUN git config --global user.email ${CONTAINER_USER_NAME}@localhost.local
RUN git config --global core.editor vim
RUN git config --global color.ui true


###### CONNECTION SETTINGS | 接続方法設定 ######
# ホスト名指定でPWレスでSSH通信できるようにしたい
RUN sudo mkdir -p /var/run/sshd
COPY supervisord.conf /etc/supervisor/supervisord.conf

# FTPの転送失敗のエラーが出ないようにしたい
RUN sudo mkdir -p /var/run/vsftpd/empty
COPY vsftpd.conf /etc/vsftpd.conf

# Open port 22 so linked containers can see it
COPY sshd_config /etc/ssh/sshd_config
RUN sudo mkdir -p /root/.ssh
COPY authorized_keys /root/.ssh/authorized_keys
COPY ssh_key /root/.ssh/ssh_key
COPY ssh_key.pub /root/.ssh/ssh_key.pub

RUN mkdir -p /home/${CONTAINER_USER_NAME}/.ssh
COPY authorized_keys /home/${CONTAINER_USER_NAME}/.ssh/authorized_keys
COPY ssh_key /home/${CONTAINER_USER_NAME}/.ssh/ssh_key
COPY ssh_key.pub /home/${CONTAINER_USER_NAME}/.ssh/ssh_key.pub
RUN echo "Host localhost" > /home/${CONTAINER_USER_NAME}/.ssh/config
RUN echo "  Hostname localhost" >> /home/${CONTAINER_USER_NAME}/.ssh/config
RUN echo "  User ${CONTAINER_USER_NAME}" >> /home/${CONTAINER_USER_NAME}/.ssh/config
RUN echo "  PreferredAuthentications publickey" >> /home/${CONTAINER_USER_NAME}/.ssh/config
RUN echo "  IdentityFile ~/.ssh/ssh_key" >> /home/${CONTAINER_USER_NAME}/.ssh/config
RUN echo "Host 127.0.0.1" >> /home/${CONTAINER_USER_NAME}/.ssh/config
RUN echo "  Hostname 127.0.0.1" >> /home/${CONTAINER_USER_NAME}/.ssh/config
RUN echo "  User ${CONTAINER_USER_NAME}" >> /home/${CONTAINER_USER_NAME}/.ssh/config
RUN echo "  PreferredAuthentications publickey" >> /home/${CONTAINER_USER_NAME}/.ssh/config
RUN echo "  IdentityFile ~/.ssh/ssh_key" >> /home/${CONTAINER_USER_NAME}/.ssh/config
RUN sudo chown ${CONTAINER_USER_NAME}:${CONTAINER_GID} /home/${CONTAINER_USER_NAME}/.ssh/*
RUN chmod 0700 /home/${CONTAINER_USER_NAME}/.ssh

# Mount data for sharing files and folders at docker environment to local machine
RUN sudo mkdir -p /mnt/src
RUN sudo chown ${CONTAINER_USER_NAME}:${CONTAINER_GID} /mnt/src
RUN sudo ln -s /mnt/src/supervisor /var/log/supervisor/
RUN ln -s /mnt/src/demo_project /home/${CONTAINER_USER_NAME}/demo_project

# Called on first run of docker - will run supervisor
COPY startup.sh /startup.sh
RUN sudo chmod 0755 /startup.sh
