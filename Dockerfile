FROM node:20 AS builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:20-slim
WORKDIR /usr/src/app
COPY --chown=node:node package*.json ./
RUN npm ci --omit=dev
COPY --from=builder --chown=node:node /usr/src/app/dist ./dist
EXPOSE 3000
USER node
CMD ["npm", "run", "start:prod"]