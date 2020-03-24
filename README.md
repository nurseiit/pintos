# Pintos in Docker

👾 + 🐋 = ❤️ Dockerized Pintos of CS140 by Stanford.

Run and check your pintos code inside a `docker` container.

## Pull the image

```
$ docker pull nurseiit/pintos:latest
```

## Run and mount the volume

```
$ docker run -it --volume $PWD/project1:/pintos nurseiit/pintos:latest
```

> Please note that the directory format is `--volume <local dir>:/<mount dir in docker>`.

> Make sure that the directory you are mounting contains `/src` as a first child. Otherwise it will conflict with `PATH` variables.

## Stopping

```
$ docker ps -a            # list all processes
$ docker rm 5e22515a0f51  # remove container
```

## To Do
* [x] Use volumes
* [ ] Configure `qemu` simulator
