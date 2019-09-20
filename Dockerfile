# We specify the base image we need for our
# go application
FROM golang:1.12.0-alpine3.9
# Set environment variables so we go Go modules in vendor mode
ENV GO111MODULE=on \
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
# we add an appuser so we don't have to run as ROOT
RUN adduser -S -D -H -h /app appuser
# modify main app to be executable
# (and read/writable) by its owner
RUN chmod 700 /app/main
# change app's owner to appuser
RUN chown appuser /app/main
# set current user to appuser
# from here on, the user is appuser not ROOT
USER appuser
# document that the app uses port 8080
EXPOSE 8080
# Our start command which kicks off
# our newly created binary executable
CMD ["./main"]
