FROM zachgray/swift-tensorflow:4.2

LABEL Description="An STS Application"

WORKDIR /usr/src

# Cache this step
COPY Package.swift /usr/src
RUN swift package update

# Add Source
ADD ./ /usr/src

# user can pass in CONFIG=release to override
ARG CONFIG=debug

RUN swift build --configuration ${CONFIG}

RUN cp ./.build/${CONFIG}/libSTSLibrary.so /usr/lib/libSTSLibrary.so
RUN cp ./.build/${CONFIG}/STSLibrary.swiftmodule /usr/lib/STSLibrary.swiftmodule
RUN cp ./.build/${CONFIG}/STSApplication /usr/bin/STSApplication

ENTRYPOINT /usr/bin/STSApplication