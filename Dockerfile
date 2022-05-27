FROM  jekyll/jekyll:4.2.2
LABEL maintainer="dazbo"

RUN   gem install bundler:2.3.14
RUN   gem update
COPY  --chown=jekyll:jekyll . /srv/config/
