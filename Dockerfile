FROM ubuntu:jammy
COPY ./ /root/dotfiles

RUN apt-get update && apt-get install -y \
  python3.10 \
  pip

RUN pip install textual

