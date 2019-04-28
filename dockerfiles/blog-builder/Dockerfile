FROM alpine:3.4

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.4/community" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk add \
    build-base \
    git \
    libatomic \
    libxml2 \
    libxml2-dev \
	libxslt \
	libxslt-dev \
	ncurses-terminfo \
	ncurses-terminfo-base \
	openssh \
	python \
	readline \
	readline-dev \
	zlib libffi-dev \
	zlib-dev

# Dependencies to run:
# jekyll to generate the static blog
# asciidoctor a much complete alternative to markdown
# pygments to support code highlighting in blog article
RUN apk add \
    graphviz \
    python \
    ruby \
    ruby-dev \
    ruby-rdoc \
    ruby-io-console \
    ruby-irb \
    ruby-json \
    ruby-rake
    
RUN gem install bundler

RUN gem install pygments.rb -v '1.1.2' && \
    gem install asciidoctor -v '1.5.5' && \
    gem install jekyll -v '3.4.3' && \
    gem install asciidoctor-diagram -v '1.5.3'

# Dependencies to support plantuml diagram into blog article
# ttf-dejavu  dependencie to fix fonts bug with alpine & jdk8
RUN apk add openjdk8 \
            ttf-dejavu 

RUN mkdir -p /blog/src
WORKDIR /blog

RUN apk add ca-certificates \
            openssl && \
    update-ca-certificates

RUN cd /tmp && \
    wget https://github.com/adnanh/webhook/releases/download/2.6.9/webhook-linux-386.tar.gz && \
    tar zxvf webhook-linux-386.tar.gz && \
    chmod +x webhook-linux-386/webhook && \
    cp webhook-linux-386/webhook /usr/bin/webhook
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

ARG blog_builder_git_url

COPY scripts /scripts
RUN chmod +x /scripts/rebuild.sh

ENTRYPOINT /usr/bin/webhook -hooks /scripts/hooks.json -verbose
