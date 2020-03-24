# Pintos in Docker

👾 + 🐋 = ❤️ Dockerized Pintos of CS140 by Stanford.

Run and check your pintos code inside a `docker` container.

## Pull the image

```
$ docker pull nurseiit/pintos:1.0
```

## Running

```
$ docker run -it nurseiit/pintos:1.0
```

## Stopping

```
$ docker ps -a            # list all processes
$ docker rm 5e22515a0f51  # remove container
```

## To Do
* [ ] Use volumes
* [ ] Configure `qemu` simulator
