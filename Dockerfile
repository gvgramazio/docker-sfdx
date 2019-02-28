FROM ubuntu:18.04
LABEL Name=sfdx Version=0.0.1
RUN apt-get -y update && apt-get install -y wget xz-utils

RUN wget https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz
RUN mkdir sfdx
RUN tar -xJf sfdx-linux-amd64.tar.xz -C sfdx --strip-components 1
RUN ./sfdx/install
RUN rm -r sfdx