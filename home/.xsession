export WINDOW_MANAGER="/usr/bin/xmonad"
#gnome-panel &
#gnome-settings-daemon &
#gnome-power-manager &
auto-dock &
qs &
#nautilus -n &
/usr/bin/avfsd -o allow_root -o intr -o sync_read ~/.avfs 
autocutsel -f
autocutsel -f -s PRIMARY
eval `ssh-agent`
#dropbox start
#gtk-redshift &
#nm-applet &
#dbus-launch --exit-with-session xmonad
#exec xmonad
keynav
synergys
gnome-session
