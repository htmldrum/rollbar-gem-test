FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install --force-yes -y\
    build-essential\
    libpq-dev\
    nodejs\
    imagemagick\
    memcached\
    nginx\
    squid3\
    emacs\
    openssh-server

ADD ./.docker/squid3.conf /etc/init/squid3.conf

ADD ./.docker/sshd_config /etc/ssh/sshd_config

RUN ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
RUN cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys

ARG APP_PATH='/app'
ARG PORT=3000

RUN mkdir $APP_PATH
WORKDIR $APP_PATH

ADD Gemfile* ./
RUN gem install bundler # run latest bundler
RUN gem install rainbow -v '2.2.1' # Bug in rails12factor requires installing this first
RUN bundle install --jobs 20 --retry 5 --without development test

# Add rest of deps here to limit image build times
ADD . ./
RUN ln -sf /dev/stdout /app/log/production.log

EXPOSE $PORT
CMD ["./bin/start"]
