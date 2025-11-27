#!/bin/bash

RED='\e[31m' # i used chatgpt for this im not smart enough
GREEN='\033[38;5;46m'
YELLOW='\e[33m'
BLUE='\e[94m'
MAGENTA='\e[35m'
CYAN='\e[36m'
WHITE='\e[97m'
RESET='\e[0m'
PINK='\033[38;5;205m'

countdown() {
    local seconds=$1
    local bar_length=30
    local spinstr='|/-\'
    local spin_index=0
    local total_steps=$((seconds * 100)) # updates every 0.01s
    local spin_delay=10 # spinner updates every 0.1s

    echo ""

    for ((step=total_steps; step>=0; step--)); do
        local remain_time=$(printf "%.2f" "$(echo "$step / 100" | bc -l)")
        local i=$((step / 100)) # whole seconds

        # bar progress based on fine-grain time
        local progress=$(( (step * bar_length) / total_steps ))
        local remaining=$(( bar_length - progress ))

        local bar_filled=""
        local bar_empty=""
        for ((j=0; j<progress; j++)); do
            bar_filled+="─"
        done
        for ((j=0; j<remaining; j++)); do
            bar_empty+="░"
        done

        # spinner animation updates slower
        if (( step % spin_delay == 0 )); then
            spin_index=$(((spin_index + 1) % ${#spinstr}))
        fi
        local spin_char="${spinstr:spin_index:1}"

        printf "\r%s [${GREEN}%s${WHITE}%s] %6.2fs${RESET}" \
            "$spin_char" "$bar_filled" "$bar_empty" "$remain_time"

        sleep 0.01
    done

    echo ""
}

sudo pacman -S --noconfirm toilet bc
echo ""
toilet -f mono12 DOTS
echo -e "${BLUE}==>${WHITE} Do not run this script as root.${RESET}"
echo -e "${BLUE}==>${WHITE} Proceeding in 5 seconds${RESET}"
echo ""
countdown 5
clear
toilet -f mono12 PACKAGES
echo -e ""
echo -e "${WHITE}--- Installing packages${RESET}"
echo -e ""
countdown 1
echo ""
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd ..
rm -rf yay-bin
git clone https://github.com/saneaspect/sf-fonts.git
cd sf-fonts
bash install.sh
cd ..
rm -rf sf-fonts
sudo pacman -Sy
sudo pacman -S --noconfirm pciutils man pavucontrol grim mpv slurp unzip ncdu curl noto-fonts-emoji zsh-autosuggestions sudo coreutils which pipewire pipewire-pulse wireplumber pamixer zsh-syntax-highlighting gparted zsh lxappearance sddm hyprland rofi-wayland swww kitty waybar cliphist playerctl pavucontrol wl-clipboard xdg-desktop-portal-hyprland xdg-utils neovim noto-fonts base-devel nerd-fonts lsd fastfetch swaync thunar cava btop bc hyprpicker
gpu_info=$(lspci | grep -E "VGA|3D")
if echo "$gpu_info" | grep -qi "NVIDIA"; then
    toilet -f mono12 DRIVERS
    echo Installing NVidia drivers
    echo ""
    sudo pacman -S --noconfirm nvidia-dkms nvidia-utils nvidia-settings
fi
toilet -f mono12 DOTS
systemctl enable sddm.service
echo -e ""
echo -e "${WHITE}--- Setting up dots"
echo -e ""
countdown 1
echo ""
chsh -s $(which zsh)
echo -e ${BLUE}==>${WHITE} copying .config/* to ~/config/
mkdir ~/.config/
sudo cp -r .config/* ~/.config/
cp -r assets/.zshrc ~/
echo -e "${BLUE}==>${WHITE} copying zsh/.zshrc to ~/ ${RESET}"
cp -r assets/.p10k.zsh ~/
echo -e "${BLUE}==>${WHITE} copying zsh/.p10k.zsh to ~/ ${RESET}"
mkdir -p ~/Pictures/wallpapers/
echo -e "${BLUE}==>${WHITE} creating ~/Pictures/wallpapers/ ${RESET}"
cp -r wallpapers ~/Pictures/
echo -e "${BLUE}==>${WHITE} copying wallpapers to ~/Pictures/ ${RESET}"
wpctl settings --save bluetooth.autoswitch-to-headset-profile false
echo -e "${BLUE}==>${WHITE} turning off headphone auto switch ${RESET}"
echo -e "${BLUE}==>${WHITE} Waiting 5 seconds before continuing ${RESET}"
countdown 5
echo ""
toilet -f mono12 FINISHED
echo -e ""
echo -e "${WHITE}--- Installation has finished${RESET}"
echo -e "${WHITE}Installation has successfully finished.${RESET}"
echo -e ""
read -p "It is recommended that you restart, Would you want to restart now? (Y/n) " answer
answer=${answer:-Y}
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    clear
    toilet -f mono12 RESTART
    echo -e "${BLUE}==>${WHITE} Rebooting in 5 seconds"
    sleep 5
    sudo reboot now
else
    systemctl start sddm.service
fi
