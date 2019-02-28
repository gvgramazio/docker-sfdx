FROM ubuntu:18.04
LABEL Name=sfdx Version=0.0.1
RUN apt-get -y update \
    && apt-get -y install \
        wget \
        xz-utils \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir sfdx
RUN wget https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz
RUN tar -xJf sfdx-linux-amd64.tar.xz -C sfdx --strip-components 1
RUN ./sfdx/install
RUN rm -r sfdx