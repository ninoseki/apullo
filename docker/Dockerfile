FROM ruby:2.7-alpine3.10
RUN apk --no-cache add git build-base ruby-dev \
  && cd /tmp/ \
  && git clone https://github.com/ninoseki/apullo.git \
  && cd apullo \
  && gem build apullo.gemspec -o apullo.gem \
  && gem install apullo.gem \
  && rm -rf /tmp/apullo \
  && apk del --purge git build-base ruby-dev

ENTRYPOINT ["apullo"]

CMD ["--help"]
