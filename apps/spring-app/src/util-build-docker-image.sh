#!/bin/env bash

set -ev

docker build \
    -t local/spring-app \
    .
