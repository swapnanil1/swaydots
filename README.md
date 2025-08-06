## Install Core Apps
```
sudo pacman -Syu --needed \
  sway swaybg swaylock swayidle ly xorg-xwayland \
  xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk xdg-user-dirs \
  fish alacritty eza thunar thunar-volman thunar-archive-plugin \
  cliphist wl-clipboard waybar wofi dunst \
  autotiling python-i3ipc ttf-jetbrains-mono-nerd ttf-font-awesome \
  nwg-look pavucontrol power-profiles-daemon lm_sensors \
  brightnessctl ddcutil grim satty ufw timeshift ristretto mpv \
  baobab gnome-system-monitor blueberry
```
## Install User Apps
```bash
flatpak install flathub \
  app.zen_browser.zen \
  org.keepassxc.KeePassXC \
  com.brave.Browser \
  org.qbittorrent.qBittorrent \
  org.telegram.desktop \
  org.onlyoffice.desktopeditors \
  org.localsend.localsend_app \
  com.dec05eba.gpu_screen_recorder \
  md.obsidian.Obsidian \
  dev.vencord.Vesktop \
  org.qownnotes.QOwnNotes \
  io.github.peazip.PeaZip \
```

## Setup Brighness using ddcutil
```
sudo pacman -S ddcutil; echo "i2c-dev" | sudo tee -a /etc/modules-load.d/i2c-dev.conf > /dev/null; sudo usermod swapnanil -aG i2c
```

# Usage

| Function | Shortcut | Application/Service |
| :--- | :--- | :--- |
| App Launcher | `Meta` + `Space` | Wofi |
| Terminal | `Meta` + `Return` | Alacritty |
| File Manager | `Meta` + `F` | Thunar |
| Web Browser | `Meta` + `C` | Firefox (or `$browser`) |
| Close Window | `Meta` + `Shift` + `Q` | Sway (kill command) |
| Clipboard History | `Meta` + `V` | Cliphist (via Wofi) |
| Screenshot (Region) | `Print` (Save) / `Shift`+`Print` (Copy) | `grim` + `slurp` |
| Lock Screen | `Meta` + `P` | swaylock |
| Notifications | (Runs automatically) | Dunst |
| Bluetooth GUI | `Meta` + `Shift` + `B` | Blueberry |
| Network GUI | `Meta` + `Shift` + `N` | Network Manager |
| Volume GUI | `Meta` + `Shift` + `V` | Pavucontrol |
| System Monitor | `Ctrl` + `Alt` + `Delete` | GNOME System Monitor|
| Polkit Agent | (Runs automatically) | xdg-desktop-portal-wlr |


# Themes
## GTK Theme

```
mkdir .themes
cd .themes
git clone https://github.com/EliverLara/Kripton
```

## GTK Icon

```
git clone https://github.com/vinceliuice/Colloid-icon-theme.git
cd Colloid-icon-theme
./install.sh -s default -t teal
```
