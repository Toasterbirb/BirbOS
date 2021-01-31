echo " ____  _      _      ___  ____  "
echo "| __ )(_)_ __| |__  / _ \/ ___| "
echo "|  _ \| | '__| '_ \| | | \___ \ "
echo "| |_) | | |  | |_) | |_| |___) |"
echo "|____/|_|_|  |_.__/ \___/|____/ "
echo ""

scriptPath=$(pwd)

echo "> Select your distro:"
echo "[1] Arch Linux"

read selection

case $selection in
	1)
		distro="Arch Linux"
		;;

	*)
		echo "Invalid selection"
		exit 0;
esac


echo $distro

rootcmd=doas

# Install packages
if [[ "$distro" == "Arch Linux" ]]
then
	echo "> Updating system"
	$rootcmd pacman -Syu --noconfirm

	echo "> Installing development packages"
	$rootcmd pacman -S --noconfirm --needed base-devel git gcr webkit2gtk

	echo "> Installing xorg packages"
	$rootcmd pacman -S --noconfirm --needed xorg-xrdb xorg-xset xorg-xauth xorg-xinit xorg-xkill xorg-xprop xorg-server xorg-xinput xorg-xrandr xorg-xkbcomp xorg-xmodmap xorg-xdpyinfo xorg-xmessage xorg-xsetroot xorg-setxkbmap xorg-fonts-type1 xorg-server-common xorg-fonts-encodings

	echo "> Installing cool programs"
	$rootcmd pacman -S --noconfirm --needed termite dunst sxhkd weechat rofi xorg mpv neovim zsh xdg-utils stow arandr htop neofetch cmus feh
fi


echo "> Installing suckless things"
sucklessPath=~/Programs/suckless
mkdir -p $sucklessPath

# Download sources
git clone https://github.com/Toasterbirb/dwm $sucklessPath/dwm
git clone https://github.com/Toasterbirb/surf $sucklessPath/surf
git clone https://github.com/Toasterbirb/dmenu $sucklessPath/dmenu
git clone https://github.com/Toasterbirb/slock $sucklessPath/slock
git clone https://github.com/Toasterbirb/slock $sucklessPath/tabbed

# Install them
cd ~/Programs/suckless/dwm
doas make install

cd ~/Programs/suckless/surf
doas make install

cd ~/Programs/suckless/dmenu
doas make install

cd ~/Programs/suckless/slock
doas make install

cd ~/Programs/suckless/tabbed
doas make install

# Clone dotfiles
echo "> Installing muh dotfiles"
cd ~
git clone https://github.com/Toasterbirb/dotfiles ~/dotfiles
cd ~/dotfiles
stow -t ~ *

# Cleaning up .xinitrc so it doesn't contain my personal launch commands
echo "sh $sucklessPath/dwm/dwmbar/dwmbar.sh &" > ~/.xinitrc
echo "feh --bg-fill $scriptPath/wallpaper.jpg" >> ~/.xinitrc
echo "sxhkd" >> ~/.xinitrc
echo "exec dwm" >> ~/.xinitrc
