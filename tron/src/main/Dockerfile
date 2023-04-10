# ---------------------------------------------------------
# Build
# ---------------------------------------------------------
FROM golang:1.20-rc-alpine AS build
LABEL maintainer="sebastian@sommerfeld.io"

COPY go /app
WORKDIR /app

RUN go mod download \
    && go test ./... \
    && go build -o target/tron .

# ---------------------------------------------------------
# Run
# ---------------------------------------------------------
FROM alpine:3.17.2 AS run
LABEL maintainer="sebastian@sommerfeld.io"

# To run integration tests with a proper shell and tools
RUN apk add --no-cache bash=5.2.15-r0 \
    && apk add --no-cache curl=7.88.1-r0
    # && apk add --no-cache jq=1.6-r2

COPY --from=build /app/target/tron /usr/bin/tron

ARG USER=tron
RUN adduser -D $USER

USER $USER

ENTRYPOINT [ "/usr/bin/tron" ]
