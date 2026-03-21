<h1 align="center">Forever Stars MacOS Screensaver</h1></br>
<p align="center">Classic Windows Starfield Screensaver done by <a href="https://www.opanoid.com/source-code/">Opanoid</a>.</p>

<p align="center">
<img src="https://github.com/seljabali/forever-stars/blob/master/screen-shots/stars.gif?raw=true" alt="" data-canonical-src="" />
</p>
</br>
Project's aim is to port over source code to Swift, as well as, have it working on Big Sur.

## Usage

All commands use `make`:

| Command | Description |
|---------|-------------|
| `make build` | Compile the screensaver into `/tmp/forever-stars-build/` |
| `make install` | Build and install to `~/Library/Screen Savers/` |
| `make run` | Build and launch the test harness (preview window) |
| `make clean` | Remove the build directory |

### Build

```sh
make build
```

### Run Test Harness

Launches a preview window to test the screensaver without installing it:

```sh
make run
```

### Install

Builds and copies the `.saver` bundle to your user Screen Savers folder:

```sh
make install
```

Open **System Settings → Screen Saver** to activate it.
