# 🟩 MineLauncher — Minecraft-Style KDE Plasma App Launcher

**MineLauncher** (package ID: `mc_inventory`) is a KDE Plasma 6 plasmoid that transforms your desktop app launcher into a **Minecraft Creative Inventory**–inspired grid.  
No icons, no fluff — just shaped slots, categories, and pure blocky goodness. 🧱
![MineLauncher Preview](preview.png)
---

## 🧩 Features

✅ Grid-based launcher UI  
✅ Category tabs (like Minecraft’s Creative tabs)  
✅ Shape-based app entries — no traditional icons  
✅ Built in pure **QML + JS** for Plasma 6  
⚠️ *Currently experimental — may crash or display incorrectly!*

---

## 📂 Folder structure

```

mc_inventory/
├── contents
│   ├── config
│   │   └── main.xml
│   └── ui
│       ├── CategoryTab.qml
│       ├── code/
│       ├── InventorySlot.qml
│       └── main.qml
├── grass_block.png
└── metadata.json

````

- `main.qml` — main UI entry point  
- `InventorySlot.qml` — renders each grid cell  
- `CategoryTab.qml` — handles category navigation  
- `code/` — your scripts (e.g., app fetch, logic)  
- `grass_block.png` — default widget icon / background  
- `metadata.json` — Plasma package metadata  

---

## ⚙️ Installation

### Local Install (Recommended for testing)
```bash
# Create the plasmoids folder if it doesn’t exist
mkdir -p ~/.local/share/plasma/plasmoids/

# Copy this project there
cp -r mc_inventory ~/.local/share/plasma/plasmoids/
````

Then right-click desktop → **Add Widgets** → search for “MineLauncher”.

If it doesn’t appear:

```bash
kbuildsycoca5 --noincremental
killall plasmashell
kstart5 plasmashell
```

---

## 💻 Manual Uninstall

```bash
rm -rf ~/.local/share/plasma/plasmoids/mc_inventory/
```

or remove manually:

```bash
rm -rf ~/.local/share/plasma/plasmoids/mc_inventory/
```

---

## 🧠 Development Notes

This project is currently in a **barely functional prototype state** — some layouts may break, and Plasma may crash under certain conditions.
Testing in a sandbox session (e.g., Xephyr) is **highly recommended**.

### Tips for contributors:

* Always keep `"Id": "mc_inventory"` in `metadata.json` matching the folder name.
* `Name` (“MineLauncher”) is just the visible label.
* Check logs with `journalctl --user -f | grep plasmashell`.

---

## 🤝 Contributing

Got QML experience? Plasma dev skills?
Even small contributions (UI cleanup, layout fix, proper category sorting, or better data model) help massively.

1. Fork this repo
2. Create a feature branch
3. Submit a Pull Request 🚀

---

## 🧱 Future Plans

* Dynamic category sorting
* Inventory animation polish
* additional ui design

---

## 📜 License

GPL-3.0+
© 2025 CAL (calamytryx)

---

### 💬 Fun Fact

> “MineLauncher” is named after the Minecraft Creative Inventory — but here, you’re not placing blocks… you’re *launching apps like items!* 😆
