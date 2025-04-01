# Build stage
FROM alpine:edge AS builder
COPY wisecow.sh /app/wisecow.sh

# Final stage
FROM alpine:edge
# Installing dependencies here
RUN apk update && \
    apk add --no-cache \
        bash \
        perl \
        netcat-openbsd \
        fortune \
        --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
        cowsay

# Copy only the script (no need to copy binaries)
COPY --from=builder /app/wisecow.sh /app/wisecow.sh

# Set up the container
WORKDIR /app
RUN chmod +x wisecow.sh
EXPOSE 4499
CMD ["/app/wisecow.sh"]
