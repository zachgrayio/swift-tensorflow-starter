#!/usr/bin/env bash
docker build -t sts-app .
docker run --rm sts-app