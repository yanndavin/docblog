FROM gogs/gogs

ENV BUILD_DEPS="gettext"  \
    RUNTIME_DEPS="libintl"
    
RUN set -x && \
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps
    
RUN mkdir -p /data/gogs/conf

COPY ./gogs/conf/app.ini.template /tmp/conf/app.ini.template

# Empty sqlite db
COPY ./gogs/data/gogs.db /data/gogs/gogs.db

