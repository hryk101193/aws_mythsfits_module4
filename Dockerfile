FROM alpine:3.7

ARG terraform_version="0.14.3"

# install terraform.
RUN wget https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip && \
    unzip ./terraform_${terraform_version}_linux_amd64.zip -d /usr/local/bin/

# set time-zone=JST
RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

# create workspace.
COPY ./terraform /root/terraform

# move to workspace
WORKDIR /root/terraform
