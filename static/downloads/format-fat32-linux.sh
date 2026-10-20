#!/usr/bin/env bash
set -euo pipefail
echo "ClosedCoreCodex - FAT32 LBA formatter voor Linux"
echo "WAARSCHUWING: de gekozen schijf wordt volledig gewist."
echo
lsblk -o NAME,SIZE,MODEL,TRAN,TYPE,MOUNTPOINTS
echo
read -r -p "Voer de HELE externe schijf in (bijv. /dev/sdb): " TARGET
if [[ ! "$TARGET" =~ ^/dev/sd[a-z]+$ ]]; then
  echo "Ongeldige schijfnaam. Verwacht bijvoorbeeld /dev/sdb. Gestopt."
  exit 1
fi
if [[ ! -b "$TARGET" ]]; then
  echo "Dit is geen bestaande block device. Gestopt."
  exit 1
fi
lsblk "$TARGET"
echo
echo "Controleer zorgvuldig dat dit de JUISTE externe USB-schijf is."
read -r -p "Typ ERASE om door te gaan: " CONFIRM
if [[ "$CONFIRM" != "ERASE" ]]; then
  echo "Geannuleerd."
  exit 1
fi
PART="${TARGET}1"
if lsblk -nr -o MOUNTPOINT "$TARGET" | grep -q '[^[:space:]]'; then
  echo "Ontkoppel eerst alle partities van deze schijf en start opnieuw."
  exit 1
fi
sudo wipefs -a "$TARGET"
sudo parted -s "$TARGET" mklabel msdos
sudo parted -s "$TARGET" mkpart primary fat32 1MiB 100%
sudo parted -s "$TARGET" set 1 lba on
sudo partprobe "$TARGET"
sleep 2
sudo mkfs.fat -F 32 -n USB "$PART"
echo "Klaar."
