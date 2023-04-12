FROM node:19.8.1-alpine
# node:19.0.0-bullseye-slim
LABEL maintainer="sebastian@sommerfeld.io"

RUN npm install --location=global @antora/cli@3.1.0 \
    && npm install --location=global @antora/site-generator@3.1.0 \
    && npm install --location=global asciidoctor@2.2.6 \
    && npm install --location=global asciidoctor-kroki@0.16.0 \
    && npm install --location=global gulp-cli@2.3.0
