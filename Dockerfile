# We'll choose the incredibly lightweight
# Go alpine image to work with
FROM golang:1.12.0 AS builder

# Set environment variables so we go Go modules in vendor mode
ENV GO111MODULE=on \
  GOOS=linux \
  GOARCH=amd64 \
  CGO_ENABLED=0 \
  GOFLAGS=-mod=vendor

# We create an /app directory within our
# image that will hold our application source
# files
RUN mkdir /app

# We copy everything in the root directory
# into our /app directory
ADD . /app

# We specify that we now wish to execute
# any further commands inside our /app
# directory
WORKDIR /app

# we run go build to compile the binary
# executable of our Go program
RUN go build -o main ./cmd

# the lightweight scratch image we'll
# run our application within
FROM alpine:latest AS production

# We have to copy the output from our
# builder stage to our production stage
COPY --from=builder /app .

# we add an appuser so we don't have to run as ROOT
RUN adduser -S -D -H -h /app appuser

# modify main app to be executable
# (and read/writable) by its owner
RUN chmod 700 /main

# change app's owner to appuser
RUN chown appuser /main

# set current user to appuser
# from here on, the user is appuser not ROOT
USER appuser

# document that the app uses port 8080
EXPOSE 8080

# we can then kick off our newly compiled
# binary exectuable!!
CMD ["./main"]
