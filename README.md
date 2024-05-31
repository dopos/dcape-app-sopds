# dcape-app-sopds

[![GitHub Release][1]][2] [![GitHub code size in bytes][3]]() [![GitHub license][4]][5]

[1]: https://img.shields.io/github/release/dopos/dcape-app-sopds.svg
[2]: https://github.com/dopos/dcape-app-sopds/releases
[3]: https://img.shields.io/github/languages/code-size/dopos/dcape-app-sopds.svg
[4]: https://img.shields.io/github/license/dopos/dcape-app-sopds.svg
[5]: LICENSE

[sopds](https://github.com/mitshel/sopds) application package for [dcape](https://github.com/dopos/dcape).

## Docker image used

* [sopds](https://hub.docker.com/zveronline/sopds) from [docker-sopds](https://github.com/zveronline/docker-sopds)

## Features

This project contains

* reference versions of core files for all of **dcape** applications since **dcape** v3:
  * [Makefile](Makefile)
  * [.drone.yml](.drone.yml)
  * [docker-compose.yml](docker-compose.yml)

## Usage

* OPDS-version: http://<Your server>/opds/
* HTTP-version: http://<Your server>/

## Requirements

* linux 64bit (git, make, sed)
* [docker](http://docker.io)
* [dcape](https://github.com/dopos/dcape) v3
* Git service ([github](https://github.com), [gitea](https://gitea.io) or [gogs](https://gogs.io))

## Install

### By mouse (deploy with drone)

1. Gitea: Fork or mirror this repo in your Git service
2. Drone: Activate repo
3. Gitea: "Test delivery", config sample will be saved to enfist
4. Enfist: Edit config and remove .sample from name
5. Gitea: "Test delivery" again (or Drone: "Restart") - app will be installed and started on webhook host

### By hands

```bash
git clone --single-branch --depth 1 https://github.com/dopos/dcape-app-sopds.git
cd dcape-app-sopds
make config
... <edit .env.sample>
mv .env.sample .env
make up
```

## Upgrade

```bash
git pull
make config
... <check .env.sample>
mv .env.sample .env
make up
```

## License

The MIT License (MIT), see [LICENSE](LICENSE).

Copyright (c) 2021 Aleksey Kovrizhkin <lekovr+dopos@gmail.com>
