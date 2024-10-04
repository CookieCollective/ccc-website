FROM node:22-alpine AS builder
WORKDIR /app
ADD . /app
RUN npm ci --legacy-peer-deps && \
    npm run build

FROM pierrezemb/gostatic
COPY headerConfig.json /config/
COPY --from=builder /app/public /srv/http
