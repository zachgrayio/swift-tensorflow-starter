FROM zachgray/swift-tensorflow:4.2

LABEL Description="An STS Application"

# Cache this step
COPY Package.swift /usr/src
RUN swift package update

# Add Source
ADD ./ /usr/src
WORKDIR /usr/src

# user can pass in CONFIG=release to override
ENV CONFIG=debug

# user can pass in LIVE=true
ENV LIVE=false

ENTRYPOINT ./entrypoint $CONFIG $LIVE