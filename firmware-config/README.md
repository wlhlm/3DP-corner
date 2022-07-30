Firmware Configuration
----------------------

This directory contains the firmware configuration for my 3D printers. I'm a big
fan of the [Klipper firmware][KlipperHomepage] which leverages the powers of a
Raspberry Pi or similar SBC. For ease of deployment my printers share a single
configuration including macros with machine-specific bits in a specific
configuration (for example v2/v2.cfg). The only thing I have to change on each
machine is the include in `klipper.cfg`.

Klipper upstream development is conservative and has become a bit bottlenecked
over the course of 2021 which has lead to the rise of a number of modules being
maintained externally. To incorporate these modules into my printer setups and
to simplify firmware management across multiple printers I have decided to start
maintaining [my own Klipper branch][WlhlmKlipperBranch]. Besides said modules
this branch may also include some of my own changes such as new functionality
I'm developing or miscellaneous fixes. All this means that just copying my
config into your own setup will mostly likely not work straight away, so it's
probably better to only copy the actual snippets that you are interested in.

[KlipperHomepage]: https://www.klipper3d.org/
[WlhlmKlipperBranch]: https://github.com/wlhlm/klipper/tree/wlhlm-main

## Printers

Printer-specific configuration notes:

### Voron V0.0

The V0 is a pretty simple printer at its core with pretty much no bells and
whistles and thus doesn't really require and rely on fancy Klipper modules.

### Voron V2.4

The V2 configuration relies on a number of extra Klipper modules:

- [Frame expansion compensation](https://github.com/Klipper3d/klipper/pull/4157)
- [Z calibration](https://github.com/protoloft/klipper_z_calibration)
- [Dockable probe](https://github.com/Klipper3d/klipper/pull/4328)

## Other Voron Klipper configurations

Here are a few Klipper configurations from which I've drawn major inspiration:

- [@alexz's V2 config](https://github.com/zellneralex/klipper_config)
- [@th3fallen's V2 config](https://github.com/th3fallen/voronConfig)
- [@retsamedoc's V2 config](https://github.com/retsamedoc/VoronV2_klipper)
- [@kmobs' V2 config](https://github.com/kmobs/3dprinting/tree/kmobs/klipper_config)
- [@rpanfili's V2 config](https://github.com/rpanfili/voron-ht)

### Annex K3 R1 beta

The K3 configuration relies, like the V2 config, on a number of extra Klipper
modules. While an additional Z endstop has been installed, it is currently
unused instead relying on the Probe for Z.

- [Frame expansion compensation](https://github.com/Klipper3d/klipper/pull/4157)
- [Dockable probe](https://github.com/Klipper3d/klipper/pull/4328)
