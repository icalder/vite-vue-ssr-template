FROM node:lts-alpine as build-stage
WORKDIR /build
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN chmod +x node_modules/.bin/vite node_modules/.bin/tsc && \
   npm run build
 
FROM node:lts-alpine as production-stage
RUN apk add --no-cache tini

WORKDIR /app
COPY --from=build-stage /build/dist/ dist/
COPY package.json package-lock.json ./
RUN npm ci --omit-dev

USER node
ENV NODE_ENV=production
EXPOSE 5173

ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "node", "./dist/express/server.js" ]