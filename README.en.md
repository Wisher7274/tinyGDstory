# tinyGDstory

A lightweight, portable story system framework developed based on Godot 4.
Suitable for games that are story-driven but not entirely story-focused.
Supports parallel animations, typewriter effects, resource management, and custom command extensions.

![Godot Version](https://img.shields.io/badge/Godot-4.6.1+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Features

- **Parallel Performance System**: Character actions, background switching, and dialogue typewriter effects run in parallel. Dialogues can start without waiting for animations to finish.
- **High-performance Tween-driven**: All animations are based on the Godot Tween system, non-blocking and high-performance.
- **JSON Script Format**: Simple and readable text scripts, support version control, convenient for writers to collaborate.
- **High Extensibility**: Supports custom commands, easily extend sound effects, screen shake, variable checks, and more.
- **Optimized Interaction**: Supports typewriter skipping, input locking, global CTC (Click to Continue) management.
- **✨ Core Feature: Frame Parallel Logic** What is frame parallel logic?
Traditional visual novel systems usually execute each operation sequentially: wait for background switch to finish, then wait for character entry to finish, and finally display dialogue. This causes a stuttering performance. This framework uses parallel execution: background switching, character entry, and dialogue display start at the same time, and only wait for player click after all are completed.

## 📦 Quick Start

1. Clone this repository into your Godot project.
2. Instantiate the `Stage.tscn` scene into your main game scene.
3. Modify the initial script path in `stage.gd`.
4. Write your story files according to `Guildance.md`.

## 📂 Project Structure

```text
├── scenes/
│   ├── Stage.tscn          # Main story stage scene
│   └── object/
│       └── Character.tscn  # Character sprite prefab
├── scripts/
│   └── Stage.gd  # Core story controller
├── source/
│   └── dialogue/           # Story text files
│   └── character/          # Character sprites
│   └── bgs/                # Background images
│   └── sound/              # Audio
│   └── font/               # Fonts
└── docs/                   # Documentation
```

## ⚠️ Known Limitations & To-Improve
This project is currently in Beta stage. The following features are planned or welcome contributions:
- 🎵 Sound System 🟡 Demo version | Currently a simple implementation; a complete audio management system is recommended for production.
- 💾 Save System 🔴 Not implemented | No mid-story save/load support yet.
- 🔀 Branch Story 🔴 Not implemented | Linear playback only, no condition checks.
- 📊 Variable System 🔴 Not implemented | Cannot store story flags.
- 🌐 Multi-language 🔴 Not implemented | Text is written directly in scripts currently.
- 📱 Mobile Adaptation 🟡 Partial support | Touch interaction needs to be adapted by yourself.
