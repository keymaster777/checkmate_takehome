FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn

ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID rails && useradd -u $UID -g $GID -m rails
USER rails

WORKDIR /app

COPY --chown=rails:rails Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=rails:rails . .

EXPOSE 3000

CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0"]