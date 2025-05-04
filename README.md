# Pause Map

A lightweight script for FiveM that auto-displays a handheld map when players open the pause menu. It includes realistic animations, object handling, and player condition checks.

## Preview

![Preview](https://i.ibb.co/RTVS0wt8/image.png)

## Installation

### 1. 📥 Download the Script

Clone or download this repository to your computer.

### 2. 📂 Add to Server Resources

Move the downloaded folder to the `resources` directory of your FiveM server.

### 3. 🛠️ Update `server.cfg`

- Open your `server.cfg` file, located in your server's main directory.
- Add `ensure ved-pauseMap` to ensure the script starts with your server.

## Changelog

**Version 1.0.0**

#### **[ Initial Release ]**

- Automatic map handling on pause menu

- Safety checks for realistic usage

- Configurable behavior and keybinding

## Features

- ✅ Auto-shows a map in the player’s hand when the pause menu opens.

- ✅ Realistic map-holding animation and object model.

- ✅ Auto-closes the map if the player:

  - Dies or ragdolls

  - Enters a vehicle

  - Switches to a weapon

- ✅ Optional key-based toggle.

- ✅ Fully configurable with clear settings and comments in config.lua.

- ✅ Clean logging system with log level filtering (INFO, WARN, ERROR).

## Configurations

All settings are easily configurable in config.lua. No coding experience needed. The config includes:

- Toggle for debug logging and log level

- Control key to manually open/close map (optional)

- Behavior settings (e.g. close on death, weapon, fall, vehicle)

- Custom model and animation support

Explore the full config here: [config.lua](https://github.com/vedrion/ved-pauseMap/blob/main/config.lua)

## Contributing

Feel free to fork this repository and create a pull request for any improvements or features!

## License

This project is licensed under the MIT License.
