FROM alpine:latest
RUN apk upgrade --update && \
    apk add \
        ca-certificates \
        ruby \
        ruby-irb \
        && \
    rm -f /var/cache/apk/* && \
    gem install -N \
        'aws-sdk:~>2' \
        json_pure \
        memoist2 \
        && \
    adduser -D user

COPY . /

USER user
WORKDIR /home/user

ENTRYPOINT ["/shutdown.rb"]
