# Post cluster setup.  Add zipkin and prometheus as Docker.  Only on Node #1
sudo docker run -d -p 9411:9411 openzipkin/zipkin