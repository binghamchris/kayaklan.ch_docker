FROM nginx:alpine

MAINTAINER Chris Bingham "chris@pearit.co.uk"

ARG KL_VERSION=1.4
ARG GOOGLE_API_KEY

WORKDIR /tmp

ADD https://github.com/binghamchris/kayaklaun.ch/archive/${KL_VERSION}.tar.gz .

RUN tar -xvf ${KL_VERSION}.tar.gz

RUN cp -r ./kayaklaun.ch-${KL_VERSION}/* /usr/share/nginx/html

RUN rm -rf ./kayaklaun.ch-${KL_VERSION}

RUN rm -rf ${KL_VERSION}.tar.gz

WORKDIR /usr/share/nginx/html

RUN KEY_LINE=$(grep -nr maps.googleapis.com index.html | cut -d : -f 1) && sed -i ${KEY_LINE}s/key=.*\&/"key=${GOOGLE_API_KEY}\&"/ index.html

RUN apk --no-cache add curl curl

#HEALTHCHECK --interval=10s --timeout=1s \
#  CMD curl -f http://localhost/ | grep -q "KayakLaun.ch"