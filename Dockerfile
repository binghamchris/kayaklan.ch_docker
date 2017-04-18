FROM nginx

MAINTAINER Chris Bingham "chris@pearit.co.uk"

ENV KL_VERSION 1.4

WORKDIR /tmp

ADD https://github.com/binghamchris/kayaklaun.ch/archive/${KL_VERSION}.tar.gz .

RUN tar -xvf ${KL_VERSION}.tar.gz

RUN cp -r ./kayaklaun.ch-${KL_VERSION}/* /usr/share/nginx/html

RUN rm -rf ./kayaklaun.ch-${KL_VERSION}

RUN rm -rf ${KL_VERSION}.tar.gz