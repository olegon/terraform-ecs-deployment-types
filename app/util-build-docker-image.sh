#!/bin/env bash

set -ev

docker build \
    -t local/node-app \
    .
