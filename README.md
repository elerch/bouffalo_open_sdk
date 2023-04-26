Bouffalo Lab (mostly) open SDK, as a docker image
=================================================

This is available prebuilt for SDK revision 2f6477f at:

  `git.lerch.org/lobo/bouffalo_open_sdk:2f6477f`

The docker image is meant to alleviate download and use of the [Bouffalo Lab
SDK](https://github.com/bouffalolab/bouffalo_sdk/tree/master/tools/bflb_tools)

Due primarily to the requirement of a fairly new version of cmake, this
is based on Debian Bookworm, which is currently in testing.

Leveraging the work done in [the Xuantie GNU Toolchain docker image](https://github.com/elerch/xuantie-gnu-toolchain-docker)
allows this image to eliminate most binary blobs. Remaining binary blobs in use
include the WiFi and the BLE drivers, all other binaries are removed during
image build.

The Dockerfile includes all details, but the general image build process
performs the following actions:

* Download specific versions of the SDK itself, the decompiled post-process tool,
  and the decompiled flashing tool
* Remove all tool binaries from the SDK
* Reconfigure cmake files to use the open source/system provided tooling
* Establish an entrypoint to allow easy compilation

Usage
-----

The entrypoint is set up to call make. The intended usage is to run the image
from within your source directory.

Build:
```
docker run --rm -t -v $(pwd):/build git.lerch.org/lobo/bouffalo_open_sdk:2f6477f flash BOARD=bl616dk CHIP=bl616
```

Flash:
```
docker run --rm --device /dev/ttyACM0 -v $(pwd):/build git.lerch.org/lobo/bouffalo_open_sdk:2f6477f flash BOARD=bl616dk CHIP=bl616 COMX=/dev/ttyACM0
```
