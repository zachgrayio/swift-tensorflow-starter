#!/usr/bin/env bash
docker build -t sts-app . && docker run --rm --entrypoint "/usr/bin/swift" sts-app test