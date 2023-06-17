# Dazbo's Jekyll

## Tagline

A Jekyll Image with prereqs installed, default config, GitHub pages support, and compose file.

## GitHub

https://github.com/derailed-dash/jekyll

## Overview

This is a modified Docker container image, based on Jekyll/Jekyll.

- It is based on Jekyll 4.2, which uses Ruby 2.7.  Since 4.2.2, Jekyll uses Ruby 3 and this seems to have broken some gems.
- It installs the appropriate Bundler version for managing Ruby gem dependencies.
- It provides some default configuration files in /srv/config/
  - A Gemfile which:
    - Installs `github-pages` gem
    - `webrick`, which is required by Jekyll, but no longer installed by default in Ruby.
    - `github-pages-unscramble`, to allow use of plugins that aren't on the GitHub Pages whitelist, locally.
    - `jekyll-spaceship`, which provides various processors, like table, mathjax, mermaid
  - A `_config.docker.yml` to allow us to run locally, and expose on localhost:4000.
  - A `docker-compose.yml` for starting and serving your site through the container; it automatically sets up environment variables and volumes.

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

At this point, make any changes you want to make to the configuration files. For example, you may wish to update the Gemfile to update jekyll and github-pages gem versions, or add any custom plugins we want to use.

If you need to update versions for GitHub Pages support, these pages will be helpful:

- [Creating a GitHub Pages Site with Jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/creating-a-github-pages-site-with-jekyll)
- [GitHub Pages Dependency Versions](https://pages.github.com/versions)

Now complete the site build from the container session:

```bash
bundle install
bundle update
exit
```

### Serving the Site

Simply launch the container as follows:

```bash
docker compose up
```

Note that this configuration monitors for changes and automatically updates the site content.

Other notes:
- If you want the Jekyll container to be able to authenticate to your GitHub repo, then you should create a `.env` file in folder where your docker-compose.yml lives, and use this to configure your GitHub token, e.g.

```bash
JEKYLL_GITHUB_TOKEN=whatever
```

## Rebuilding the Image

If the image is ever updated, we'll want to update the tag and push to docker.io. E.g.

```bash
# build
docker image build -t daz502/jekyll:ver .
docker tag daz502/jekyll:ver daz502/jekyll:latest

# push
docker push daz502/jekyll:ver
docker push daz502/jekyll:latest
```

### Version History

|Version|Changes|
|-------|-------|
|0.3|Moved default content to a defaults folder, so that we don't accidentally replace the README.md in an existing site when building a new site|
|0.2|First working version|