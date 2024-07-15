#!/bin/bash

clear

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print centered text
print_centered() {
    local term_width=$(tput cols)
    local text="$1"
    local text_width=${#text}
    local padding=$(( (term_width - text_width) / 2 ))
    printf "%*s%s%*s\n" $padding "" "$text" $padding ""
}

# Print welcome message
echo
echo -e "${BLUE}"
print_centered "**************************************"
print_centered "*                                    *"
print_centered "*   Welcome to Thian Tools Project   *"
print_centered "*                                    *"
print_centered "**************************************"
echo -e "${NC}"
echo

echo -e "${GREEN}Please move the APK file that will be processed to the folder \"decompiler/apk/\" and remember its name${NC}"

home_folder="$ROOT"
dir_out="jdk"
dir_work="$ROOT/jdk"

echo -e "${CYAN}Pilih opsi:${NC}"
echo -e "${YELLOW}1) CFR [a fast decompiler]${NC}"
echo -e "${YELLOW}2) FERNFLOWER [first decompiler]${NC}"
echo -e "${YELLOW}3) JADX [optimized]${NC}"
echo -e "${YELLOW}4) JDCMD${NC}"
echo -e "${YELLOW}5) JEB3${NC}"
echo -e "${YELLOW}6) PROCYON [slow but more accurate]${NC}"

echo

valid_choice=false
while [ "$valid_choice" = false ]; do
    read -p "Please select decompiler (number): " c1
    case "$c1" in
        1) decompiler="CFR"; valid_choice=true ;;
        2) decompiler="FERNFLOWER"; valid_choice=true ;;
        3) decompiler="JADX"; valid_choice=true ;;
        4) decompiler="JDCMD"; valid_choice=true ;;
        5) decompiler="JEB3"; valid_choice=true ;;
        6) decompiler="PROCYON"; valid_choice=true ;;
        *) echo -e "${RED}Invalid selection, please try again.${NC}" ;;
    esac
done

echo

APK_FOLDER="$ROOT/sdcard/decompiler/apk"

# Menyimpan daftar nama file APK ke variabel
list_file=($(ls $APK_FOLDER/*.apk | xargs -n 1 basename))

valid_file_choice=false
while [ "$valid_file_choice" = false ]; do
    # Menampilkan daftar file dengan nomor
    echo -e "${CYAN}Select the APK file from the following list:${NC}"
    for i in "${!list_file[@]}"; do
        echo -e "${YELLOW}$((i+1)). ${list_file[$i]}${NC}"
    done

    # Meminta pengguna untuk memilih nomor file
    read -p "Enter the file number you want to select: " choice

    # Memeriksa apakah pilihan valid
    if [[ $choice -gt 0 && $choice -le ${#list_file[@]} ]]; then
        selected_file=${list_file[$((choice-1))]}
        valid_file_choice=true
        echo
        echo -e "${GREEN}You selected file: $selected_file${NC}"
    else
        echo -e "${RED}Invalid selection, please try again.${NC}"
    fi
done

nama_apk="$selected_file"

# Lokasi penuh APK
apk_path="$APK_FOLDER/$nama_apk"

# Extract the base name of the apk file without extension
apk_name=$(basename "$nama_apk" .apk)

# Define the output directory based on the decompiler and apk name
output_dir="$ROOT/sdcard/decompiler/output/$decompiler/$apk_name"

# Create the output directory if it does not exist
mkdir -p "$output_dir"

# Jalankan decompiler
java -jar ./ThianTools.jar -decompile $decompiler "$apk_path" "$output_dir"

