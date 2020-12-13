# Base
FROM node:12 AS base

WORKDIR /app

# Dependencies
COPY package*.json ./
RUN npm install

# Build
COPY . .
RUN npm run build

# Application
FROM node:12-alpine AS application

COPY --from=base /app/package*.json ./
RUN npm install --only=production && npm install pm2@4.5.0 -g
COPY --from=base /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["pm2-runtime", "dist/main.js"]