# -*- sh -*-
FROM fcat/ubuntu-universe:12.04

# Development tools
RUN apt-get -qy install git vim tmux

# Tuby 1.9.3 and build dependencies
RUN apt-get -qy install ruby1.9.1 ruby1.9.1-dev build-essential libpq-dev libv8-dev libsqlite3-dev

# Bundler
RUN gem install bundler

# Create a "rails" user
# The Rails application will live in the /rails directory
RUN adduser --disabled-password --home=/rails --gecos "" rails

# Copy the Rails app
ADD . /rails

# Make sure we have rights on the rails folder
RUN chown rails -R /rails

# Execute the setup script
# This will run bundler, setup the database, etc.
RUN su rails -c /rails/scripts/setup

EXPOSE 3000
USER rails
CMD /rails/scripts/start
