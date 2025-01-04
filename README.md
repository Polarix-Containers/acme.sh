# acme.sh

![Build, scan & push](https://github.com/Polarix-Containers/acme.sh/actions/workflows/build.yml/badge.svg)

### Features & usage
- Rebases the [official image](https://github.com/acmesh-official/acme.sh/wiki/Run-acme.sh-in-docker) to latest Alpine, to be used as a drop-in replacement.
- Automatic update is disabled by default. Set `AUTO_UPGRADE=1` environment if you want to automatically update. Since this container is rebuilt daily, it is better practice to just pull a new build of the container.

### Licensing
- Licensed under GPL 3 to comply with licensing by acme.sh.
- Any image built by Polarix Containers is provided under the combination of license terms resulting from the use of individual packages.
