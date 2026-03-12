FROM node:20-alpine AS builder

RUN apk add --no-cache git

WORKDIR /app
RUN git clone --depth 1 https://github.com/ByMykel/CSGO-API.git .
RUN npm install
RUN npm run update-data-force
RUN npm run group-data-force
RUN npm run generate-docs

FROM nginx:alpine

RUN apk add --no-cache curl

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/public /usr/share/nginx/html
