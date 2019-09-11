FROM node:12.3.1-alpine

# Install app dependencies
ENV NPM_CONFIG_LOGLEVEL warn
ENV NPM_CONFIG_UNSAFE_PERM true

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Installs latest Chromium (72) package.
RUN apk update && apk upgrade && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
    curl \
    bash \
    git \
    openssh \
    tzdata \
    chromium@edge=72.0.3626.121-r0 \
    nss@edge \
    freetype@edge \
    harfbuzz@edge \
    ttf-freefont@edge

RUN apk add --no-cache --virtual deps \
  python \
  build-base 

# Add user so we don't need --no-sandbox.
RUN mkdir -p /home/node/Downloads /home/node/app

# install global deps
RUN npm install -g pm2 nodemon@latest serve ngrok hotel json-server

# Timezone
ENV TZ Australia/Perth

# Run everything after as non-privileged user.
# USER node

# command
# CMD [ "pm2", "start", "--no-daemon" ]
