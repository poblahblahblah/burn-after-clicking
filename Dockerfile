FROM ruby:3.3.0
RUN apt-get update -qq && apt-get install -y postgresql-client
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | apt-get install -y nodejs
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
RUN RAILS_GROUPS=assets bundle exec rake assets:precompile

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000 9395

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
