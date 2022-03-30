FROM ubuntu:20.04
USER root

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update --fix-missing && apt install -y \
    git \
    python3 \
    python3-pip \
    libssl-dev \
    libcurl4-openssl-dev \
    gettext


# Installing git v2.17.1
# This version of git is the latest version that support nested 
# subtrees
RUN git clone -b v2.17.1 https://github.com/git/git.git
RUN cd git && make NO_TCLTK=NoThanks prefix=/usr all && make prefix=/usr install
RUN cd .. & rm -rf git
RUN ln -s /usr/lib/git-core/git-subtree /usr/bin
RUN git --version

COPY requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt

COPY src /root/src
COPY entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]