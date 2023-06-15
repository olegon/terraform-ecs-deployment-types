FROM node:18

WORKDIR /opt/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8080

USER nobody

CMD [ "node", "index.mjs" ]
