# Source scripts in /etc/X11/xinit/xinitrc.d/
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi
WM=${1:-awesome}
exec /bin/zsh -c "
source ~/.oh-my-zsh-custom/paths.zsh
xscreensaver -no-splash &
devmon &
wmname LG3D
xrdb -merge ~/.Xresources
xsetroot -cursor_name left_ptr
dropbox start &
xbindkeys &
keynav &
auto-dock &
parcellite &
$1
"
#exec awesome
