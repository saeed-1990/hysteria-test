FROM alpine:latest

RUN apk update && apk add --no-cache curl unzip

RUN mkdir -m 777 /xray

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
