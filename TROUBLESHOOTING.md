# Troubleshooting

Work through this top to bottom - most setup problems are one of the first few rows.

## Toolchain and environment

| Symptom                                        | Fix                                                                                                   |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `west: command not found`                      | Virtualenv not activated. Run `source .venv/bin/activate` (needed in every new terminal).             |
| `west update` is slow / stalls                 | It's cloning the Zephyr tree - this is the big download. Let it finish; don't cancel.                 |
| `west build` fails after editing DTS / Kconfig | Rebuild with `--pristine`.                                                                            |
| Build fails right after setup                  | Confirm `west list` shows `zephyr`, `cmsis_6`, `hal_nxp` under `deps/`. If not, re-run `west update`. |

## Flashing the board (pyOCD)

| Symptom                                      | Fix                                                                                      |
| -------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `pyocd: no probe found`                      | Run `pyocd list`. If empty: try the board's other USB port (debug vs target), or replug. |
| `pyocd: target type not recognized`          | Device pack missing. Run `pyocd pack install MCXA156`, then retry.                       |
| pyOCD permission errors on the probe (Linux) | Install the CMSIS-DAP udev rules - see [Linux USB permissions](#linux-usb-permissions).  |
| Nothing happens after flash                  | Reset the board (reset button), or re-flash with `west flash --runner pyocd --erase`.    |

## Serial console

| Symptom                             | Fix                                                                                                |
| ----------------------------------- | -------------------------------------------------------------------------------------------------- |
| LED blinks but no serial output     | Wrong port or baud. Confirm 115200 baud and the right device (see below).                          |
| `Permission denied` opening the tty | Add yourself to the `dialout` group (Linux) - see [Linux USB permissions](#linux-usb-permissions). |

Open the console with any of:

```bash
minicom -D /dev/ttyACM0 -b 115200
picocom -b 115200 /dev/ttyACM0
tio /dev/ttyACM0
```

## Linux USB permissions

On Linux you typically need two things before the probe and serial port work without
`sudo`. Worth doing before the workshop, but we can also handle it together at the start.

### 1. Serial port access (`dialout` group)

```bash
sudo usermod -aG dialout $USER
```

Then **log out and back in** (group membership only applies on a new login).

### 2. CMSIS-DAP udev rules for the probe

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/pyocd/pyOCD/main/udev/50-cmsis-dap.rules \
  -o /etc/udev/rules.d/50-cmsis-dap.rules

sudo udevadm control --reload-rules
sudo udevadm trigger
```

**Unplug and replug the board** afterward.
Then `pyocd list` should show the probe without `sudo`.

## Alternative flash runners (if pyOCD doesn't work for you)

pyOCD is the default and needs no NXP account. If it won't cooperate on your machine:

- **LinkServer** (NXP's official tool, free NXP account required):
  `west flash --runner linkserver`
  - https://www.nxp.com/design/design-center/software/development-software/mcuxpresso-software-and-tools-/linkserver-for-microcontrollers:LINKERSERVER
- **J-Link** (requires re-flashing the MCU-Link probe to J-Link firmware via NXP's
  LPCScrypt): `west flash --runner jlink`
