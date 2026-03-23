<p align="center">
<img src="https://github.com/seljabali/forever-stars/blob/master/screen-shots/stars.gif?raw=true" alt="" data-canonical-src="" />
</p>
<h1 align="center">Forever Stars MacOS Screensaver</h1></br>
<p align="center">MacOS screensaver remake of <a href="https://www.opanoid.com/source-code/">Windows's Starfield Screensaver</a> remake.</p>
<p align="center">Revised from a project initially written by <a href="https://www.opanoid.com/source-code/">Schlotts Opanoid</a>.</p>

## Installation
#### 1. Download from Github
* Download `Forever Stars.saver` from latest release.
* Open file to install
* Open **System Settings → Screen Saver** to activate it, under `Others`.

#### 2. Compile & install locally
* Clone the project
* Run `make install` locally at project's root
* Open **System Settings → Screen Saver** to activate it, under `Others`.


## CLI Commands

| Command | Description |
|---------|-------------|
| `make build` | Compile the screensaver into `/tmp/forever-stars-build/` |
| `make install` | Build and install to `~/Library/Screen Savers/` |
| `make run` | Build and launch the test harness (preview window) |
| `make clean` | Remove the build directory |
