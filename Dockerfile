FROM alpine:latest

RUN apk update && apk add --no-cache curl unzip openssl

RUN mkdir -m 777 /xray
RUN mkdir -p /xray/cert

# تولید گواهی خودامضا
RUN openssl req -x509 -nodes -newkey rsa:2048 -keyout /xray/cert/key.pem -out /xray/cert/cert.pem -days 3650 -subj "/CN=localhost"

RUN ARCH=$(uname -m); \
    if [ "$ARCH" = "x86_64" ]; then ARCH="64"; \
    elif [ "$ARCH" = "aarch64" ]; then ARCH="arm64-v8a"; \
    else ARCH="64"; fi; \
    curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-${ARCH}.zip && \
    unzip /tmp/xray.zip -d /xray && \
    rm /tmp/xray.zip && \
    chmod +x /xray/xray

COPY config.json /xray/config.json

CMD ["/xray/xray", "run", "-config", "/xray/config.json"]
