<p align="center">
<img src="screen-shots/stars.gif" alt="Forever Stars screensaver preview" />
</p>
<h1 align="center">Forever Stars</h1>
<p align="center">A macOS screensaver — a Swift remake of the classic Windows Starfield.</p>
<p align="center">
  <img src="https://github.com/sami-eljabali/forever-stars-macos-screensaver/actions/workflows/build.yml/badge.svg" alt="Build" />
</p>

## Installation

#### Download (recommended)
1. Download `Forever Stars.saver` from the [latest release](../../releases/latest)
2. Open the file to install
3. **System Settings → Wallpaper → Screen Saver... → Others → View All → Forever Stars**

#### Build from source
1. Clone the repo
2. Run `make install`
3. **System Settings → Wallpaper → Screen Saver... → Others → View All → Forever Stars**

## Commands

| Command | Description |
|---------|-------------|
| `make build` | Compile into `/tmp/forever-stars-build/` |
| `make install` | Build and install to `~/Library/Screen Savers/` |
| `make run` | Build and launch the test harness (preview window) |
| `make clean` | Remove the build directory |

## Configuration

At the top of `ForeverStarsView.swift`, two constants control periodic appearance changes:

| Constant | Default | Description |
|----------|---------|-------------|
| `randomizeSpeedEnabled` | `false` | Randomly vary star speed over time |
| `randomizeColorEnabled` | `false` | Randomly shift star color over time |
