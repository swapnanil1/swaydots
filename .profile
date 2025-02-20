# ~/.profile - Set up environment for Wayland and common apps
# QT Themeing
export QT_STYLE_OVERRIDE=kvantum
export QT_QPA_PLATFORMTHEME=qt6ct

# General Wayland Variables
export GDK_BACKEND=wayland
export QT_QPA_PLATFORM=wayland
export CLUTTER_BACKEND=wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=sway
export XCURSOR_SIZE=24

# Force Chrome/Chromium to use Wayland
export CHROME_USE_WAYLAND=1

# Force Electron apps to attempt to use the Wayland protocol for rendering
export ELECTRON_OZONE_PLATFORM_HINT=wayland

# Firefox - Enable Wayland support
export MOZ_ENABLE_WAYLAND=1

# VLC (Force Wayland backend for video output)
export VLC_FORCE_WAYLAND=1

# Optional: For SDL-based Apps (games, etc.)
export SDL_VIDEODRIVER='wayland,x11'

# Optional: For Clutter-based Applications
export CLUTTER_BACKEND=wayland

# Optional: For Java Apps running smoothly under wayland
export _JAVA_AWT_WM_NONREPARENTING=1

# End of ~/.profile setup

