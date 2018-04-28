#!/usr/bin/env bash
docker build -t sts-app .
docker run --rm -v ${PWD}:/usr/src \
    --entrypoint /usr/bin/swift \
    sts-app \
    package generate-xcodeproj

