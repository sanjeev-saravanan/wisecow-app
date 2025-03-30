# Build stage (only for building the script, not needed for cowsay)
FROM alpine:edge AS builder
COPY wisecow.sh /app/wisecow.sh

# Final stage
FROM alpine:edge
# Install ALL dependencies here (simpler than copying files)
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
