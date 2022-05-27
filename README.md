# Dazbo's Jekyll

## Tagline

A Jekyll Image with prereqs installed, default config, GitHub pages support, and compose file.

## Overview

This is a modified Docker container image, based on Jekyll/Jekyll.

- It installs the appropriate Bundler version for managing Ruby gem dependencies.
- It installs the webrick gem, which is required by Jekyll, but no longer installed by default in Ruby
- It provides some default configuration files in /srv/config/
  - A Gemfile which installs GitHub Pages gem, and latest compatible version of Jekyll.
  - A _config.docker.yml to allow us to run locally, and expose on localhost:4000.
  - A docker-compose.yml for serving your site through the container; it automatically sets up environment variables and volumes.

## Usage Instructions

### For Initial Site Creation

Pre-reqs: that we have created the folder where our site will live, and that this folder is the CWD.

Run the container interactively:

```bash
docker run -e "JEKYLL_ENV=docker" --rm -it -v "${PWD}:/srv/jekyll" -p 127.0.0.1:4000:4000 daz502/jekyll:0.1 sh
```

From the interactive session, we can perform some initial configuration:

```bash
# Initial site creation
jekyll new --force --skip-bundle .

# Copy our default config into the working volume; preserve file attributes (i.e. jekyll owner)
# This includes a default Gemfile. We need this before we run the bundle install
cp -p ../config/* .
```

At this point, make any changes you want to make to the configuration files.

Now complete the site build from the container session:

```bash
bundle install
exit
```

### Serving the Site

Simply launch the container as follows:

```bash
docker compose up
```

Note that this configuration monitors for changes and automatically updates the site content.

## Rebuilding the Image

If the image is ever updated, we'll want to update the tag and push to docker.io. E.g.

```bash
# build
docker image build -t daz502/jekyll:tagname .

# push
docker push daz502/jekyll:tagname
```