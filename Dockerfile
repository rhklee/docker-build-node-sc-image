ARG NODE_VERSION
FROM node:$NODE_VERSION

ARG SC_VERSION
ARG SC_PROJECT_BASE="sc-${SC_VERSION}-linux"

RUN apt-get install curl
RUN curl -O "https://saucelabs.com/downloads/${SC_PROJECT_BASE}.tar.gz"

RUN tar xf "${SC_PROJECT_BASE}.tar.gz"
RUN mv ${SC_PROJECT_BASE}/bin/sc /usr/local/bin/sc
RUN rm ${SC_PROJECT_BASE}.tar.gz && rm -rf ${SC_PROJECT_BASE}
