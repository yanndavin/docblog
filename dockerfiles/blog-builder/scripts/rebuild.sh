#!/bin/sh
([ ! -d .git ] && git clone -c http.sslVerify=false ${BLOG_BUILDER_GIT_URL} . || true) && \
git pull && \
bundle install && \
bundle exec jekyll build -d ../dist
