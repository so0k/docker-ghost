FROM node:0.10.31

# Set environment variables
ENV NODE_ENV production
ENV GHOST_VERSION 0.5.8

# Set up application
#ADD . /usr/src/app
#WORKDIR /usr/src/app
# Install dependencies
#RUN npm install

#install wget
RUN \
    apt-get update && \
    apt-get install wget unzip -y && \
    apt-get autoremove -y

# Download & Install specified ghost release
RUN \
    cd /tmp && \
    wget https://github.com/TryGhost/Ghost/releases/download/$GHOST_VERSION/Ghost-$GHOST_VERSION.zip && \
    unzip Ghost-$GHOST_VERSION.zip -d /ghost && \
    rm -f Ghost-$GHOST_VERSION.zip && \
    cd /ghost && \
    npm install --production && \
    sed 's/127.0.0.1/0.0.0.0/' /ghost/config.example.js > /ghost/config.js 

ENV USER_UID 500
ENV USER_GID 500

#add ghost user
RUN \
    groupadd --gid $USER_GID ghost && \
    useradd -d /ghost -m ghost --uid $USER_UID --gid $USER_GID --shell /bin/bash

# Add files.
ADD start.bash /ghost-start

# Define mountable directories.
VOLUME ["/data", "/ghost-override"]

# Define working directory.
WORKDIR /ghost

# Define default command.
CMD ["bash", "/ghost-start"]

# Expose ports.
EXPOSE 2368