#!/bin/sh

# ----------------------------------------------------------------

# 1. VALIDATE FRP_MODE
# ----------------------------------------------------------------

if [ -z "$FRP_MODE" ]; then
    echo "❌ ERROR: FRP_MODE environment variable is missing."
    exit 1
fi

# ----------------------------------------------------------------
# 2. MODE: SERVER
# ----------------------------------------------------------------
if [ "$FRP_MODE" = "server" ]; then
    echo "🔵 Mode: SERVER (frps)"

    # Validation
    if [ -z "$BIND_PORT" ]; then echo "❌ Error: BIND_PORT is missing."; exit 1; fi
    if [ -z "$FRP_AUTH_TOKEN" ]; then echo "❌ Error: AUTH_TOKEN is missing."; exit 1; fi


    # Generate Config
    cp /etc/frp/frps.template.toml /etc/frp/frps.toml
    sed -i "s|{{BIND_PORT}}|$BIND_PORT|g" /etc/frp/frps.toml
    sed -i "s|{{FRP_AUTH_TOKEN}}|$FRP_AUTH_TOKEN|g" /etc/frp/frps.toml


    echo "✅ Configuration generated. Starting server on port $BIND_PORT..."
    exec /usr/bin/frps -c /etc/frp/frps.toml

# ----------------------------------------------------------------
# 3. MODE: CLIENT
# ----------------------------------------------------------------
elif [ "$FRP_MODE" = "client" ]; then
    echo "🟢 Mode: CLIENT (frpc)"

    # Validation

        if [ -z "$SERVER_ADDR" ]; then echo "❌ Error: SERVER_ADDR is missing (IP/Domain of FRPS)."; exit 1; fi
    if [ -z "$SERVER_PORT" ]; then echo "❌ Error: SERVER_PORT is missing (Port of FRPS, usually 7000)."; exit 1; fi
    if [ -z "$FRP_AUTH_TOKEN" ]; then echo "❌ Error: FRP_AUTH_TOKEN is missing."; exit 1; fi
    if [ -z "$PROXY_NAME" ];  then echo "❌ Error: PROXY_NAME is missing (Must be unique for every tunnel)."; exit 1; fi
    if [ -z "$LOCAL_IP" ];    then echo "❌ Error: LOCAL_IP is missing (IP of the service to expose, e.g., 127.0.0.1)."; exit 1; fi
    if [ -z "$LOCAL_PORT" ];  then echo "❌ Error: LOCAL_PORT is missing (Port of the service to expose)."; exit 1; fi
    if [ -z "$REMOTE_PORT" ]; then echo "❌ Error: REMOTE_PORT is missing (Public port to open on the server)."; exit 1; fi

    # Generate Config
    cp /etc/frp/frpc.template.toml /etc/frp/frpc.toml
    sed -i "s|{{SERVER_ADDR}}|$SERVER_ADDR|g" /etc/frp/frpc.toml
    sed -i "s|{{SERVER_PORT}}|$SERVER_PORT|g" /etc/frp/frpc.toml
    sed -i "s|{{FRP_AUTH_TOKEN}}|$FRP_AUTH_TOKEN|g" /etc/frp/frpc.toml
    sed -i "s|{{PROXY_NAME}}|$PROXY_NAME|g" /etc/frp/frpc.toml
    sed -i "s|{{LOCAL_IP}}|$LOCAL_IP|g" /etc/frp/frpc.toml
    sed -i "s|{{LOCAL_PORT}}|$LOCAL_PORT|g" /etc/frp/frpc.toml

    sed -i "s|{{REMOTE_PORT}}|$REMOTE_PORT|g" /etc/frp/frpc.toml

    echo "✅ Configuration generated. Connecting to $SERVER_ADDR:$SERVER_PORT..."
    exec /usr/bin/frpc -c /etc/frp/frpc.toml


# ----------------------------------------------------------------
# 4. INVALID MODE CATCH
# ----------------------------------------------------------------
else
    echo "❌ ERROR: Invalid FRP_MODE: '$FRP_MODE'"
    echo "   Allowed values: 'server' or 'client'"
    exit 1
fi
