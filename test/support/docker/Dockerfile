FROM ubuntu

RUN apt-get update && apt-get install -y
RUN apt-get update && apt-get install -y build-essential
RUN apt-get update && apt-get install -y openssh-server
RUN apt-get update && apt-get install -y --fix-missing git

# Create git user
RUN groupadd -g 1001 git && useradd -g git -d /home/git -m git
RUN chsh --shell /bin/bash git

WORKDIR /home/git
RUN mkdir .ssh && chmod 700 .ssh
RUN touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys

# Create git repository
RUN mkdir -p /opt/git/project.git

WORKDIR /opt/git/project.git

RUN git init --bare && chown -R git:git .

# Adds public ssh key to access repository
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDayrTQZRUPrjPCyTTj7q87/7EDYp1mT6RTXmsQmgRGZ153LM4QEtWSKOQyxH3lu4nLTl+tCtsMdrr2eNQ3im/T03/SJia66CT6OaUdj6ljJTxSQiQWdwcFsHExw9kvXWQjEUTdXXmAE35DpOuuXLYuM5qlnxXRPhV/0r+uYg9e5flo/rAMxkiVOoATetJazU2jTy2wjde6EWM/W5iQhqHj5nsuSw8tjR4H69ABR/LNh+J0bVhNdvol4nkSzhf0P7jz493tsyOtL3gN2HcvOMQnx7tQySwEiINTB/yF927fkWTdEt5Nd6WQwjOjICL/0DGlJQVgY4WSHTsXwpUK/1I/ david.saenz.tagarro@gmail.com' >> /home/git/.ssh/authorized_keys

EXPOSE 22

# Cleanup
WORKDIR /home/git
