default: build run
build:
  docker image build --build-arg PASS=0806 -t arch-test -f ./setup/docker/arch.Dockerfile .
run: build
  docker container run -it --rm arch-test:latest


