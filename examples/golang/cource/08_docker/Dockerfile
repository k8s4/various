# Build
FROM golang:1.23.2-alpine AS build

WORKDIR /app
COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./
RUN go build -o /server

# Deploy
FROM alpine

WORKDIR /
COPY --from=build /server /server

USER nonroot:nonroot
EXPOSE 8080
ENTRYPOINT ["/server"]