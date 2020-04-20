FROM ruby:2.7

ENV RUBYOPT '-W:no-deprecated  -W:no-experimental'

RUN apt-get update -yqq \
		&& apt-get install -yqq --no-install-recommends \
		postgresql-client vim nodejs \
		&& rm -rf /var/lib/apt/lists

WORKDIR /usr/src/app

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

ADD Gemfile .
ADD Gemfile.lock .
 RUN bundle install

COPY . .

EXPOSE 4000
CMD rails server -b 0.0.0.0 -p 4000