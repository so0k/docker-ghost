FROM node:0.10.35

# Set environment variables
ENV NODE_ENV production

# Set up application
ADD . /usr/src/app
WORKDIR /usr/src/app

# Install dependencies
RUN npm install

# Set up application-specific files
RUN mkdir /data
RUN ln -s /data/config.js /usr/src/app/config.js
RUN ln -s /data/content /usr/src/app/content

# Expose port
EXPOSE 2368

# Run application
CMD ["npm", "start"]
