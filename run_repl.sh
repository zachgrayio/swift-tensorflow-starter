#!/usr/bin/env bash
docker build -t sts-app . && docker run --rm --security-opt seccomp:unconfined -it \
    --entrypoint /usr/bin/swift \
    sts-app \
    -I/usr/lib/swift/clang/include \
    -I/usr/src/STSLibrary \
    -L/usr/src/STSLibrary \
    -lSTSLibrary \
    -lswiftPython \
    -lswiftTensorFlow
