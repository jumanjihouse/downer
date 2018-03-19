FROM alpine:3.7

# Version is set from ci/build.
ARG VERSION

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
