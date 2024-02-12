FROM ruby:3.0.5-alpine3.16

RUN apk add --no-cache --update python3 py-pip git build-base libxml2-dev libxslt-dev bash
RUN pip install boto s3cmd

RUN echo "#!/bin/sh" >> /entrypoint.sh &&  \
    echo "echo '127.0.0.1 posttest.localhost v2.bucket.localhost' >>/etc/hosts" >>/entrypoint.sh && \
    echo 'exec "$@"' >>/entrypoint.sh && \
    chmod +x /entrypoint.sh
COPY fakes3.gemspec Gemfile Gemfile.lock /app/
COPY lib/fakes3/version.rb /app/lib/fakes3/

WORKDIR /app

RUN gem update --system 3.3.26
RUN gem install bundler:2.4.22

RUN bundle install

COPY . /app/

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
