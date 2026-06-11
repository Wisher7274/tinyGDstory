<div align="center">

# tinyGDstory

![Godot Version](https://img.shields.io/badge/Godot-4.6.1+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

🌐 **Languages:** English | [中文](README.md)

A lightweight, portable visual novel framework built for Godot 4.
Designed for games that require storytelling but aren't entirely narrative-driven. 
Supports parallel animations, typewriter effects, resource management, and custom command extensions.
![Preview](docs/preview_img.png)
</div>

---

## Before We Start

- This project is primarily for learning purposes. Beginners interested in game development are welcome to join.
- The core logic follows a **legacy coding style**. While AI tools have optimized certain parts (code comments, specific implementations), there might be inconsistencies with the author's original intent.
- Developed alongside the author's indie game project, this framework will receive continuous updates and maintenance.
- Due to academic commitments, the author hasn't touched this repo in a while. A complete rewrite is planned, ~~but all work will commence gradually after **June 9, 2026** (`hint`).~~**Rewrite is in process now, the auther have plenty of time!**
- Discussion and contributions are welcome!

## ✨ Features

- **JSON Script Format**: Human-readable text scripts that support version control (Git), facilitating collaboration with writers.

> The author's proudest feature ↓ o(〃＾▽＾〃)o

- **Frame-level Parallel Logic**:
  Traditional systems execute operations sequentially (e.g., wait for background change -> wait for character entry -> show dialogue), causing choppiness. This framework uses parallel execution: background changes, character entries, and dialogue display start simultaneously, waiting for player input only after all complete.

## 📦 Quick Start

- Clone this repository and open the Demo in the Godot editor.
- Copy the `scene` and `script` folders into your Godot project directory.
- Modify the initial script path in `stage.gd`.
- Write your story file following `Guilder.md` -> [Guilder.md](docs/Guilder.md)

## 📂 Project Structure

```text
├── scenes/
│   ├── Stage.tscn          # Main storyline stage scene
│   └── object/
│       └── Character.tscn  # Character sprite prefab
├── scripts/
│   └── Stage.gd            # Core storyline controller
├── source/
│   └── dialogue/           # Script text files
│   └── character/          # Character sprite variations
│   └── bgs/                # Background images
│   └── sound/              # Audio files
│   └── font/               # Fonts
└── docs/                   # Documentation
```

## Development Roadmap

This project is currently in the experimental stage. The following plans are already on our development schedule. Contributions are always welcome!

### Current Plans

- Rewrite of the story parsing and playback system *(Work in Progress)*
- Redesign of the script format and performance logic *(Work in Progress)*

### Future Plans

- UI redesign
- Visual/GUI editor

### Long-term Vision

- AI-Galgame
