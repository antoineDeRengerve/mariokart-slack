FROM debian:stable

ENV BUNDLER_VERSION 2.2.7

SHELL ["/bin/bash", "-l", "-c"]
RUN touch /root/.bashrc

WORKDIR /code

RUN apt -y update && apt -y upgrade

# Install required libs
RUN apt -y install git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libpq-dev procps

# Ruby and rvm
RUN \curl -sSL https://get.rvm.io | bash
RUN usermod -a -G rvm root 
RUN apt -y install rubygems ruby-dev

# bundler and gems

ADD .ruby-version /code/

RUN echo "source /usr/local/rvm/scripts/rvm" >> ~/.bashrc

RUN rvm install "ruby-$(cat .ruby-version)"
RUN rvm use --default $(cat .ruby-version)
RUN gem update --system
RUN gem install bundler

ADD Gemfile* /code/
ADD Rakefile /code/
ADD config.ru /code/
ADD app.rb /code/

RUN bundle install

# Clean up
RUN apt -y remove --purge git autoconf bison build-essential libssl-dev
RUN apt -y autoremove
RUN apt clean


# JS requirements
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
RUN nvm install 14
RUN nvm use 14
RUN npm install --global yarn
ADD package.json /code/
ADD webpack.config.js /code/
ADD yarn.lock /code/
RUN yarn install
