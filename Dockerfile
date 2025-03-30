# Build stage
FROM alpine:edge AS builder
RUN apk update && \
    apk add --no-cache bash netcat-openbsd && \
    apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing fortune cowsay
COPY wisecow.sh /app/wisecow.sh

# Final stage
FROM alpine:edge
# Install minimal runtime dependencies (optional, see notes)
RUN apk add --no-cache perl && \
    rm -rf /var/cache/apk/*
# Copy necessary binaries and data
COPY --from=builder /usr/bin/fortune /usr/bin/fortune
COPY --from=builder /usr/share/fortune /usr/share/fortune
COPY --from=builder /usr/games/cowsay /usr/games/cowsay
COPY --from=builder /usr/lib/perl5 /usr/lib/perl5
COPY --from=builder /usr/bin/nc /usr/bin/nc
COPY --from=builder /app/wisecow.sh /app/wisecow.sh
# Set working directory
WORKDIR /app
# Make script executable
RUN chmod +x /app/wisecow.sh
# Strip binaries to reduce size
RUN strip /usr/bin/fortune /usr/games/cowsay /usr/bin/nc
# Expose port
EXPOSE 4499
# Run the script (no bash needed if shebang is adjusted)
CMD ["/app/wisecow.sh"]
