<h1 align="center">FrontiersForge</h1>
<p align="center">
  <a href="https://github.com/mmvest/FrontiersForge/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/mmvest/FrontiersForge.svg?style=flat-square"/>
  </a>
  <br>
  A framework for managing custom UI elements and accessing game data from EverQuest Online Adventures Frontiers (EQOA) on the PCSX2 emulator.
</p>

## Overview

FrontiersForge is a Lua-based API designed to help developers create custom UI addons and access game data from EverQuest Online Adventures Frontiers as run on the [Sandstorm Server](https://eqoa.live/) using the [PCSX2 emulator](https://pcsx2.net/). This project piggybacks off the [UiForge](https://github.com/mmvest/User-Interface-Forge) project, providing an easy way to interact with the game's internal structures and display that data via custom UI elements powered by [ImGui](https://github.com/ocornut/imgui).

### Note: This is in a "pre-alpha" state. The implementation will likely change regularly. Expect large breaking changes to any mods created using these modules.

### ⚠️ **WARNING**:
Use this code at your own risk. UiForge injects code into the PCSX2 emulator and grants access to the game’s memory. Only place trusted scripts in the `scripts` and `scripts/modules` directory.

## Requirements

- **[PCSX2](https://pcsx2.net/)**: Tested on 64-bit versions of PCSX2 v2.0.2 and v2.2.0, running on Windows 11. Other versions may work, but they haven't been tested. This will almost certainly crash 32-bit version of PCSX2 (for now...).
- **DirectX 11**: Currently UiForge only supports DirectX 11, so be sure PCSX2 is using that for rendering.
- **Windows OS**: This definitely works on Windows 11 64-bit. I imagine it would also work on Windows 10 and maybe Windows 7. 
- **EQOA: Frontiers (US Version)**: This has only been tested on the US version of EverQuest Online Adventures: Frontiers.

## Setup and Running

1. Clone the repository:
    ```bash
    git clone https://github.com/mmvest/FrontiersForge.git
    cd FrontiersForge
    ```

1. Make sure you have **PCSX2 v2.0.2** or **v2.2.0** and **EQOA: Frontiers (US Version) ISO**.
1. Place your UI Lua scripts (dubbed ForgeScripts by the UiForge Project) in the `scripts` directory.
1. Run `pcsx2-qt.exe`, start EQOA, and then execute `StartFrontiersForge.bat`.

Once started, the UiForge settings icon should appear in the top-left corner. Click on it to see the UiForge menu.

## Roadmap

- **Current Work**: 
  - Finish Modules:
    - Ability bar module
    - Toolbelt module
    - Ability list module (accessing the abilities in your Abilities menu) 

  
- **Future Plans**:
  - Inventory module for accessing inventory items
  - Developing a community-driven wiki for sharing findings and collaborating on reverse-engineering the game’s data structures.
  - Expand on the current modules
    - e.g. Reversing camera functionality to enable customization of its anchor point and unlock vertical movement.

## Modules

### `ff_camera.lua`
Handles camera functionality, including retrieving the camera's current coordinates (`x`, `y`, `z`).

### `ff_entity.lua`
Manages in-game entities and allows you to fetch data like health, coordinates, and names of entities within the game.

### `ff_input.lua`
Provides access to controller input, including button states and analog stick movement.

### `ff_player.lua`
Exposes player-specific data, such as name, level, stats (strength, dexterity, etc.), health, and power.

### `ff_ui.lua`
Enables toggling of various UI elements such as the ability bar, chat window, health bar, etc.

### `ff_util.lua`
Includes utility functions for interacting with the game’s memory, converting strings, and calculating experience requirements.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contributing

Contributions are welcome! If you want to help improve the project, open an issue or submit a pull request. Feel free to suggest features or report bugs.
  
