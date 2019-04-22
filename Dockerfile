FROM node:8.9.0
MAINTAINER Michael Greenshtein
COPY ./app /usr/src/app
WORKDIR /usr/src/app
RUN npm install
CMD ["npm", "start"] 