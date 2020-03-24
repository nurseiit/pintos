# Pintos in Docker

👾 + 🐋 = ❤️ Dockerized Pintos of CS140 by Stanford.

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/nurseiit/pintos)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/nurseiit/pintos/latest)

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

## Gotchas

### Using `qemu` simulator
For the `qemu` simulator to work as intended, one needs to do the
following to fix an ACPI bug as described
[here](http://arpith.xyz/2016/01/getting-started-with-pintos/)
under "Troubleshooting". 

```
$ sed -i '/serial_flush ();/a outw( 0x604, 0x0 | 0x2000 );' /pintos/src/devices/shutdown.c
```

## To Do
* [x] Use volumes
* [x] Configure `qemu` simulator (partially)
* [ ] Make `qemu` work out of the box
