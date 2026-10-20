#!/bin/bash
set -e
echo "ClosedCoreCodex - FAT32 LBA formatter voor macOS"
echo "WAARSCHUWING: de gekozen schijf wordt volledig gewist."
echo
diskutil list
echo
read -r -p "Voer de externe schijf in (bijv. /dev/disk2): " TARGET
if [[ ! "$TARGET" =~ ^/dev/disk[0-9]+$ ]]; then
  echo "Ongeldige schijfnaam. Gestopt."
  exit 1
fi
diskutil info "$TARGET"
echo
echo "Controleer hierboven zorgvuldig dat dit de JUISTE externe schijf is."
read -r -p "Typ ERASE om door te gaan: " CONFIRM
if [[ "$CONFIRM" != "ERASE" ]]; then
  echo "Geannuleerd."
  exit 1
fi
diskutil eraseDisk FAT32 USB MBRFormat "$TARGET"
echo "Klaar."
