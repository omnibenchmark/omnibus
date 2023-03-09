FROM ubuntu:latest

# Update and install packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    make \
    libssl-dev libbz2-dev libncurses5-dev  libreadline-dev libgdbm-dev libnss3-dev libffi-dev libsqlite3-dev \
    r-base


# Install omnibus
COPY . /root/omnibus
WORKDIR /root/omnibus
RUN make install

# Install omnibus dependencies
RUN bash bin/omnivir.sh -l
