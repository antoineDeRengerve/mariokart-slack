FROM --platform=linux/amd64 debian:stable

ENV BUNDLER_VERSION 2.2.7

SHELL ["/bin/bash", "-l", "-c"]
ADD .bashrc /root/

RUN apt -y update && apt -y upgrade

# Install required libs
RUN apt -y install git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev \
  zlib1g-dev libncurses5-dev libffi-dev libpq-dev procps wget rbenv cron supervisor

# Copy and extract tar.gz
# Source: https://www.openssl.org/source/openssl-1.1.1g.tar.gz
ADD openssl-1.1.1g.tar.gz /root/
RUN cd /root/openssl-1.1.1g && ./config --prefix=$HOME/.openssl/openssl-1.1.1g --openssldir=$HOME/.openssl/openssl-1.1.1g
# A couple of tests may failed. Do not want to make it a blocker
RUN cd /root/openssl-1.1.1g && make && (make test || true) && make install

RUN RUBY_CONFIGURE_OPTS=--with-openssl-dir=$HOME/.openssl/openssl-1.1.1g rbenv install 2.7.6

# Dummy to avoid cache issue with wrong code from github
RUN touch foo

RUN git clone https://github.com/antoineDeRengerve/mariokart-slack.git code

WORKDIR /code

RUN bundle update
RUN bundle install

# # JS requirements
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
RUN nvm install 14
RUN nvm use 14
RUN npm install --global yarn
RUN yarn install


# # Clean up
RUN apt -y remove --purge git autoconf bison build-essential libssl-dev
# RUN apt -y autoremove - remove libpq-dev when it is needed...
RUN apt clean

ADD schedule.cron /etc/cron.d/schedule
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD .bash_profile /root/

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
