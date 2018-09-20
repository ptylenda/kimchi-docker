#!/bin/bash

docker build --build-arg https_proxy=$HTTP_PROXY --build-arg http_proxy=$HTTP_PROXY --build-arg HTTP_PROXY=$HTTP_PROXY --build-arg HTTPS_PROXY=$HTTP_PROXY --build-arg NO_PROXY=$NO_PROXY  --build-arg
no_proxy=$NO_PROXY -t kimchi .
