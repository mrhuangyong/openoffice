docker rm -f openoffice
docker run -it --name openoffice -p 8100:8100 openoffice:latest