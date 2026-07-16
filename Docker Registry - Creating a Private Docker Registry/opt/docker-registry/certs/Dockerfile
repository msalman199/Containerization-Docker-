FROM alpine:latest
RUN apk add --no-cache curl
COPY . /app
WORKDIR /app
CMD ["echo", "Hello from private registry!"]
