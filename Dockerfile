# Build stage
FROM golang:latest as build

WORKDIR /app
COPY go.mod ./
RUN go mod download

# Copy the necessary files of application
COPY main.go .
COPY static ./static

# build the binary of app named "main"
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# 2nd stage, run the binary of application
FROM scratch

# Copy "main" binary and static folder into current dir
COPY --from=build /app/main .
COPY --from=build /app/static ./static

EXPOSE 3000

# execute the binary
CMD ["./main"]
