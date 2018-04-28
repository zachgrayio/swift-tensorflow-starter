FROM zachgray/swift-tensorflow:4.2

MAINTAINER Zach Gray (zgray@scal.io)
LABEL maintainer="Zach Gray <zgray@scal.io>"
LABEL Description="Dockerized Swift for TensorFlow Starter Repository"

# Cache this step
COPY Package.swift /usr/src
RUN swift package update

# Add Source
ADD ./ /usr/src
WORKDIR /usr/src

# user can pass in CONFIG=release to override
ARG CONFIG=debug

RUN swift build --configuration ${CONFIG}
RUN ln -s ./.build/${CONFIG} ./STSLibrary
RUN ln -s ./.build/${CONFIG}/STSApplication ./STSApplication

ENTRYPOINT ./STSApplication