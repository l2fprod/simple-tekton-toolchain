FROM node:alpine

RUN apk update && apk upgrade

# Install the application
ADD package.json /app/package.json
RUN cd /app && npm install
COPY app.js /app/app.js

# Support to for arbitrary UserIds
# https://docs.openshift.com/container-platform/3.11/creating_images/guidelines.html#openshift-specific-guidelines
RUN chmod -R u+x /app && \
    chgrp -R 0 /app && \
    chmod -R g=u /app /etc/passwd

WORKDIR /app

ENV PORT 8080
EXPOSE 8080

# Define command to run the application when the container starts
CMD ["node", "app.js"]
