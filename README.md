# Alpine

## aria2

```sh
# Build
sudo ACBUILD_ARGS_DEBUG=false RKTLABS_OS=alpine RKTLABS_APP=aria2 ./build.sh

# Boot
sudo RKT_ARGS_DEBUG=false RKT_ARGS_DAEMON=false RKTLABS_OS=alpine RKTLABS_APP=aria2 ./boot.sh
```

## i2pd

```sh
# Build
sudo ACBUILD_ARGS_DEBUG=false RKTLABS_OS=alpine RKTLABS_APP=i2pd ./build.sh

# Boot
sudo RKT_ARGS_DEBUG=false RKT_ARGS_DAEMON=false RKTLABS_OS=alpine RKTLABS_APP=i2pd ./boot.sh
```

## playground

```sh
# Build
sudo ACBUILD_ARGS_DEBUG=false RKTLABS_OS=alpine RKTLABS_APP=playground ./build.sh

# Boot
sudo RKT_ARGS_DEBUG=false RKT_ARGS_DAEMON=false RKTLABS_OS=alpine RKTLABS_APP=i2pd ./boot.sh
```

# Ubuntu

## btsync

```sh
# Build
sudo ACBUILD_ARGS_DEBUG=false RKTLABS_OS=ubuntu RKTLABS_APP=btsync ./build.sh

# Boot
sudo RKT_ARGS_DEBUG=false RKT_ARGS_DAEMON=false RKTLABS_OS=ubuntu RKTLABS_APP=btsync ./boot.sh
```

## rslsync

```sh
# Build
sudo ACBUILD_ARGS_DEBUG=false RKTLABS_OS=ubuntu RKTLABS_APP=rslsync ./build.sh

# Boot
sudo RKT_ARGS_DEBUG=false RKT_ARGS_DAEMON=false RKTLABS_OS=ubuntu RKTLABS_APP=rslsync ./boot.sh
```
