docker build -t frp-tunnel:latest -f ./build/frp-tunnel.Dockerfile .

docker save frp-tunnel:latest -o ./frp-tunnel.tar
