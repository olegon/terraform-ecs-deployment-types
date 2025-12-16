FROM node:24-alpine

# Used for health checks
RUN apk add --no-cache curl

WORKDIR /opt/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8080

USER nobody

CMD [ "node", "index.mjs" ]
