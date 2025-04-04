## Install 
```
paru -S fish sway ly swaybg swaylock swayidle swaync waybar wofi grim slurp pavucontrol alacritty xorg-xwayland cliphist polkit lxqt-policykit wayland-protocols xdg-desktop-portal xdg-desktop-portal-wlr xdg-user-dirs xdg-utils ttf-jetbrains-mono-nerd python-i3ipc lxappearance git ufw eza timeshift cronie archlinux-xdg-menu nemo ristretto xed nemo-fileroller xreader satty i3-gnome-pomodoro firefox discord telegram-desktop keepassxc mpv qbittorrent bleachbit onlyoffice steam wine-staging goverlay lutris heroic-games-launcher-bin noise-suppression-for-voice
```
## Setup Autotiling 
Install python-i3ipc then rename and insert [main](https://github.com/nwg-piotr/autotiling/blob/master/autotiling/main.py) script's content under usr/bin/autotiling 

```
sudo chsh -s /usr/bin/fish swapnanil
sudo chmod +x usr/bin/autotiling
```

## Setup Brighness using ddcutil
```
sudo pacman -S ddcutil; echo "i2c-dev" | sudo tee -a /etc/modules-load.d/i2c-dev.conf > /dev/null; sudo usermod swapnanil -aG i2c
```
## Fix Fixing the empty “open with” in Dolphin in Any WM (if using dolphin)
```
sudo pacman -S archlinux-xdg-menu
XDG_MENU_PREFIX=arch- kbuildsycoca6
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
