# ---------- Stage 1: Build ----------
FROM golang:1.24 AS builder

WORKDIR /app
COPY . .

# Disable CGO and force Linux AMD64 build for portability
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -a -installsuffix cgo -o server main.go

# ---------- Stage 2: Run ----------
FROM alpine:latest

WORKDIR /root/
COPY --from=builder /app/server .

# Make sure binary has execute permissions
RUN chmod +x /root/server

EXPOSE 8080
CMD ["./server"]

