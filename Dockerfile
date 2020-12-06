FROM ruby:2.7.2

RUN apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends \
    apt-transport-https

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get update -yqq && \
  apt-get install -yqq --no-install-recommends \
  nodejs 

RUN npm install -g yarn
ENV APP_HOME /usr/src/app

COPY Gemfile* $APP_HOME/
COPY package.json yarn.lock $APP_HOME/

WORKDIR $APP_HOME

ENV BUNDLE_PATH /gems
ENV BUNDLER_VERSION=2.1.4

RUN gem update --system && \
    gem install bundler -v $BUNDLER_VERSION

RUN bundle install -j 4
RUN yarn install

COPY . /usr/src/app/

# ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
