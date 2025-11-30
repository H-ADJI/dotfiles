default: build run
build:
  podman image build --build-arg PASS=0806 -t arch-test -f ./setup/Containerfile .
run: build
  podman container run -it --rm arch-test:latest


