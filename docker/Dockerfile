ARG RUBY_VERSION=3.1.0-jemalloc
# ruby & memory bloat
# https://evilmartians.com/chronicles/fullstaq-ruby-first-impressions-and-how-to-migrate-your-docker-kubernetes-ruby-apps-today
FROM quay.io/evl.ms/fullstaq-ruby:2.7.5-jemalloc-bullseye-slim

RUN apt-get update -qq && apt-get install -y nodejs npm default-mysql-client default-libmysqlclient-dev libsqlite3-dev build-essential libxml2 libxml2-dev zlib1g-dev libxslt-dev git
RUN npm install --global yarn
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

# Add a script to be executed every time the container starts.
COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]