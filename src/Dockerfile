FROM alpine:latest

# Version is tracked here and in circle.yaml
ENV VERSION 2.1.32

RUN apk upgrade --update && \
    apk add \
        ca-certificates \
        ruby \
        ruby-irb \
        && \
    rm -f /var/cache/apk/* && \
    gem install -N \
        "aws-sdk:=${VERSION}" \
        json_pure \
        memoist2 \
        && \
    adduser -D user

COPY . /

USER user
WORKDIR /home/user

ENTRYPOINT ["/shutdown.rb"]
