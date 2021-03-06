FROM golang:1.14.4-alpine3.12

WORKDIR /go/src/github.com/mgerb/ServerStatus
ADD . .
RUN apk add --no-cache git alpine-sdk
RUN go get -u github.com/golang/dep/cmd/dep
RUN dep ensure
RUN make linux


FROM alpine:3.12

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
WORKDIR /server-status
COPY --from=0 /go/src/github.com/mgerb/ServerStatus/dist/ServerStatus-linux .
ENTRYPOINT ./ServerStatus-linux
