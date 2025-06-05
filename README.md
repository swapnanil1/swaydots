## Install Core Apps
```
sudo pacman -Syu --needed \
  sway swaybg swaylock swayidle ly xorg-xwayland \
  xdg-desktop-portal xdg-desktop-portal-wlr xdg-user-dirs \
  fish alacritty eza thunar thunar-volman thunar-archive-plugin \
  cliphist wl-clipboard lxsession-gtk3 waybar wofi dunst \
  autotiling python-i3ipc ttf-jetbrains-mono-nerd ttf-font-awesome \
  nwg-look pavucontrol power-profiles-daemon lm_sensors \
  brightnessctl ddcutil grim satty ufw timeshift
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
  com.github.KRTirtho.Spotube
```

## Setup Brighness using ddcutil
```
sudo pacman -S ddcutil; echo "i2c-dev" | sudo tee -a /etc/modules-load.d/i2c-dev.conf > /dev/null; sudo usermod swapnanil -aG i2c
```

# Usage

| Function          | Shortcut     | Using             |
| ----------------- | ------------ | ----------------- |
| App Launcher      | Meta+D       | Wofi              |
| Clipboard History | Meta+P       | Chiphist          |
| ScreenShot        | Meta+Shift+P | FlameShot         |
| Close Window      | Meta+Shift+Q | Sway              |
| Browser           | Meta+B       | Firefox           |
| FileManager       | Meta+E       | nemo              |
| Terminal          | Meta+Return  | Alacritty         |
| Notifications     | Meta+N       | Swaync            |
| Start Pomodoro    | Meta+K       | i3-gnome-pomodoro |
| Toggle Pomodoro   | Meta+L       | i3-gnome-pomodoro |
| Polkit agent      | None         | lxqt-policykit    |
| Bluetooth         | None         | blueman or bluetuith|


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
