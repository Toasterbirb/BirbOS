echo " ____  _      _      ___  ____  "
echo "| __ )(_)_ __| |__  / _ \/ ___| "
echo "|  _ \| | '__| '_ \| | | \___ \ "
echo "| |_) | | |  | |_) | |_| |___) |"
echo "|____/|_|_|  |_.__/ \___/|____/ "
echo ""

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

echo -n "> Do you want to use [s]udo or [d]oas to run root commands? (S/d): "
read rootcmd
if [ -z $rootcmd ]
then
	echo "> Defaulting to sudo"
	rootcmd=sudo
else
	if [[ "$rootcmd" == "s" ]]
	then
		echo "> Using sudo"
		rootcmd=sudo
	elif [[ "$rootcmd" == "d" ]]
	then
		echo "> Using doas"
		rootcmd=doas
	else
		echo "> Invalid option. Quitting..."
		exit 0
	fi
fi


# Install packages
if [[ "$distro" == "Arch Linux" ]]
then
	echo "> Updating system"
	$rootcmd pacman -Syu --noconfirm

	echo "> Installing development packages"
	$rootcmd pacman -S --noconfirm --needed base-devel git

	echo "> Installing xorg packages"
	$rootcmd pacman -S --noconfirm --needed xorg-xrdb xorg-xset xorg-xauth xorg-xinit xorg-xkill xorg-xprop xorg-server xorg-xinput xorg-xrandr xorg-xkbcomp xorg-xmodmap xorg-xdpyinfo xorg-xmessage xorg-xsetroot xorg-setxkbmap xorg-fonts-type1 xorg-server-common xorg-fonts-encodings

	echo "> Installing cool programs"
	$rootcmd pacman -S --noconfirm --needed termite dunst sxhkd weechat rofi xorg mpv neovim zsh xdg-utils stow arandr
fi


echo "> Installing suckless things"
sucklessPath=~/Programs/suckless
mkdir $sucklessPath

# Download sources
git clone https://github.com/Toasterbirb/dwm $sucklessPath/dwm
git clone https://github.com/Toasterbirb/surf $sucklessPath/surf
git clone https://github.com/Toasterbirb/dmenu $sucklessPath/dmenu
git clone https://github.com/Toasterbirb/slock $sucklessPath/slock

# Install them
sh ~/Programs/suckless/dwm/install.sh
sh ~/Programs/suckless/surf/install.sh
sh ~/Programs/suckless/dmenu/install.sh
sh ~/Programs/suckless/slock/install.sh

# Clone dotfiles
echo "> Installing muh dotfiles"
cd ~
git clone https://github.com/Toasterbirb/dotfiles ~/dotfiles
cd ~/dotfiles
stow -t ~ *

# Cleaning up .xinitrc so it doesn't contain my personal launch commands
echo "exec dwm" > ~/.xinitrc
