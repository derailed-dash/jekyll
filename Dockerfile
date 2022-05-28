# Don't go newer than 4.2, since with 4.2.2 we go to Ruby 3, which breaks some Jekyll stuff
FROM  jekyll/jekyll:4.2.0
LABEL maintainer="dazbo"

RUN   gem install bundler:2.3.14
RUN   gem update
COPY  --chown=jekyll:jekyll . /srv/config/
