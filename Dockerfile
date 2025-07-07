# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install 

# Bundle app source
COPY . .

# Build the backend application
RUN npm run build


# Final stage
FROM node:lts-alpine3.20
WORKDIR /usr/src/app

#Install pm2 runtime
RUN npm install pm2 -g

COPY --chown=node:node --from=build /usr/src/app/node_modules ./node_modules

COPY --from=build /usr/src/app/.next ./.next

COPY --from=build /usr/src/app/package*.json ./

COPY --from=build /usr/src/app/.env ./env

EXPOSE 22230

CMD npm start
