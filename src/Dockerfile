FROM alpine:3.9

# Version is set from ci/build.
ARG VERSION

RUN apk upgrade --update && \
    apk add \
        ca-certificates \
        ruby \
        ruby-etc \
        ruby-irb \
        && \
    rm -f /var/cache/apk/* && \
    gem install -N \
        "aws-sdk-ec2:=${VERSION}" \
        json_pure \
        memoist2 \
        && \
    adduser -D user

COPY . /

USER user
WORKDIR /home/user

ENTRYPOINT ["/shutdown.rb"]
