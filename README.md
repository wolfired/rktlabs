# Alpine

## playground

```sh
# Build
sudo acbuild_args_debug=false rktlabs_os=alpine rktlabs_app=playground ./build.sh

# Boot
sudo rkt_args_debug=false rkt_args_daemon=false rktlabs_os=alpine rktlabs_app=playground ./boot.sh
```

## aria2

```sh
# Build
sudo acbuild_args_debug=false rktlabs_os=alpine rktlabs_app=aria2 ./build.sh

# Boot
sudo rkt_args_debug=false rkt_args_daemon=false rktlabs_os=alpine rktlabs_app=aria2 ./boot.sh
```

## i2pd

```sh
# Build
sudo acbuild_args_debug=false rktlabs_os=alpine rktlabs_app=i2pd ./build.sh

# Boot
sudo rkt_args_debug=false rkt_args_daemon=false rktlabs_os=alpine rktlabs_app=i2pd ./boot.sh
```

# Ubuntu

## playground

```sh
# Build
sudo acbuild_args_debug=false rktlabs_os=ubuntu rktlabs_app=playground ./build.sh

# Boot
sudo rkt_args_debug=false rkt_args_daemon=false rktlabs_os=ubuntu rktlabs_app=playground ./boot.sh
```

## btsync

```sh
# Build
sudo acbuild_args_debug=false rktlabs_os=ubuntu rktlabs_app=btsync ./build.sh

# Boot
sudo rkt_args_debug=false rkt_args_daemon=false rktlabs_os=ubuntu rktlabs_app=btsync ./boot.sh
```

## rslsync

```sh
# Build
sudo acbuild_args_debug=false rktlabs_os=ubuntu rktlabs_app=rslsync ./build.sh

# Boot
sudo rkt_args_debug=false rkt_args_daemon=false rktlabs_os=ubuntu rktlabs_app=rslsync ./boot.sh
```

## transmission

```sh
# Build
sudo acbuild_args_debug=false rktlabs_os=ubuntu rktlabs_app=transmission ./build.sh

# Boot
sudo rkt_args_debug=false rkt_args_daemon=false rktlabs_os=ubuntu rktlabs_app=transmission ./boot.sh
```

# Kill running rkt

```
Ctrl + ]]]
```