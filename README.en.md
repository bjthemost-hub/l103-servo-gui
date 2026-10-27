# L103MotorControl — Qt host application for CH32L103 joint-motor drivers

[中文](README.md) | [English](README.en.md)

A Windows GUI for **CH32L103 joint-motor driver boards**. One UI covers both:

| Board | Driver | Encoder | Firmware repo |
|---|---|---|---|
| L103 + DRV8313 | `DRV8313` | `AS5600` (I2C) | [`l103-drv8313-as5600`](https://github.com/bjthemost-hub/l103-drv8313-as5600) |
| L103 + DRV8316C | `DRV8316C` | `MT6701` (SPI) | [`l103-drv8316c-joint`](https://github.com/bjthemost-hub/l103-drv8316c-joint) |

![screenshot](docs/media/gui.png)

> The cover screenshot was **captured by an AI agent operating this program** (see the badge in the
> bottom-right corner).

MIT License.

---

## Why it exists

Tuning these boards used to mean typing commands into a serial terminal — `G1.8888@600`,
`*{0,60,90,0}{1000000,-60,90,0}`, switching modes with `M1` / `M2` — plus hand-packing the 8-byte
little-endian CAN frames. One wrong field and the mechanism really does run away. This application
turns the firmware command set into a UI: if it can be clicked, it does not need to be typed.

## Features

| Page / area | What it does |
|---|---|
| Connection | UART console (**115200 8N1**) and CAN (**1 Mbps**); CAN works with either a WCH CH9433 EVB (raw frames) or a DM-USB2CAN adapter (30-byte envelope) |
| Target device | CAN ID = `(node << 5) \| function`; node 0 broadcasts, 1-63 are device addresses. Multiple boards can share one bus |
| Device table | Auto-discovers online nodes; click a row to retarget; shows state / position / speed / current |
| Motion | Enable, disable / release, stop, clear fault, set mechanical zero, recalibrate current zero, **align** |
| Position (PV) | Absolute or relative target in turns or degrees; "current to target", go, return to mechanical zero |
| Speed | Continuous run with start and stop |
| Open loop | Direct voltage and frequency, no feedback — **the first step after swapping a board, a motor or a phase order** |
| Parameters | Per-board table (16 items on L103, 27 on the bridge board), read/write RAM and **save to Flash**; the UI only sends, business logic stays in firmware |
| Sequence | Multi-segment sequences, assign segments per node, then broadcast the start |
| Waveform | Live phase-current traces (UART stream, 9 bytes per frame) |
| Log | Every frame sent and received, with an option to show raw hex |

## Build

Requires **Qt 5.14.0 MinGW 64** (with `Qt5SerialPort`):

```powershell
pwsh -NoProfile -File scripts\build.ps1     # qmake + mingw32-make
pwsh -NoProfile -File scripts\deploy.ps1    # copy the Qt runtime DLLs next to the exe
build\L103MotorControl.exe
```

The Qt path (`C:\Qt\Qt5.14.0\5.14.0\mingw73_64`) is set at the top of those two scripts.

**CAN needs a vendor DLL**: `USBCANx64.dll` from the WCH CH9433 EVT package. The program looks for it
in this order: next to the exe, in the working directory, then `third_party\CH9433EVT\lib\` relative to
the exe. Without it the app still runs; only the CAN page finds no devices — UART is unaffected.

## Documentation

- `docs/使用说明.md` — page-by-page operation guide, safe startup order, troubleshooting (Chinese).
- `docs/需求文档_V1.0.md` — requirement-by-requirement record of each UI behaviour, with sources (Chinese).

> **The GUI is only a middleman**: it sends exactly what the buttons say. Limits and protection live in
> the firmware. Alignment drags the rotor hard — make sure the shaft turns freely first, and stop
> immediately on no-rotation, vibration, or speed that does not track.

## AI assistance

The UI, the protocol layer and the documentation were written with **substantial AI assistance**
(OpenAI Codex / GPT models), including the README cover screenshot, which an AI agent captured from the
running application and labelled. The code was reviewed by a human and validated against two real boards.
AI is a tool, not an author.

## License

MIT, see `LICENSE`.