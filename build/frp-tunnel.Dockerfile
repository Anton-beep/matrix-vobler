FROM alpine:3.23

ENV FRP_VERSION=0.65.0
ENV ARCH=amd64

WORKDIR /app

RUN apk add --no-cache curl tar

RUN curl -L https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${ARCH}.tar.gz -o frp.tar.gz && \
    tar -zxvf frp.tar.gz && \
    mv frp_${FRP_VERSION}_linux_${ARCH}/frps /usr/bin/frps && \
    mv frp_${FRP_VERSION}_linux_${ARCH}/frpc /usr/bin/frpc && \
    rm -rf frp.tar.gz frp_${FRP_VERSION}_linux_${ARCH} && \
    mkdir -p /etc/frp

COPY configs/frps.toml /etc/frp/frps.template.toml
COPY configs/frpc.toml /etc/frp/frpc.template.toml
COPY scripts/dockerEntrypoints/tunnelEntrypoint.sh /tunnelEntrypoint.sh

RUN chmod +x /tunnelEntrypoint.sh

ENTRYPOINT ["/tunnelEntrypoint.sh"]
