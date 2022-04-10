FROM ubuntu:18.04
USER root

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update --fix-missing && apt install -y \
    git \
    python3 \
    python3-pip


RUN git --version

COPY requirements.txt /requirements.txt
RUN pip3 install --upgrade pip
RUN pip3 install -r /requirements.txt

COPY src /root/src
COPY entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]