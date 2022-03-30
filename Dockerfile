FROM ubuntu:20.04
USER root

RUN apt update && apt install -y \
    git \
    python3 \
    python3-pip

COPY requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt

COPY src /root/src
COPY entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]