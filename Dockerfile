FROM ruby:2.6.6

RUN apt-get update -yqq \
		&& apt-get install -yqq --no-install-recommends \
		postgresql-client vim nodejs \
		&& rm -rf /var/lib/apt/lists

ENV APP_NAME maawol_engine
ENV APP_PATH /usr/src/app
ENV PATH $APP_PATH/bin:$APP_PATH/spec/dummy/bin:$PATH
ENV BUNDLE_PATH /gems

WORKDIR $APP_PATH

ADD . $APP_PATH

EXPOSE 4000
CMD ./docker-entrypoint.sh