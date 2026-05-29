#!/bin/bash
# update.sh - Cloud Repository Index Compiler for GitHub Actions

echo "[*] Setting up Debian binary scanning utilities..."
# Mise à jour rapide des paquets et installation silencieuse de dpkg-dev (qui contient dpkg-scanpackages)
sudo apt-get update -yqq && sudo apt-get install -yqq dpkg-dev >/dev/null 2>&1

echo "[*] Starting Cydia Repository Indexing..."

# 1. Sécurité : Vérifier si le dossier des tweaks existe
if [ ! -d "debs" ]; then
    echo "[!] Error: 'debs' directory not found. Creating empty shell..."
    mkdir -p debs
fi

# 2. Nettoyage des anciens index de production
rm -f Packages Packages.bz2 Packages.gz 2>/dev/null

# 3. Compilation officielle via dpkg-scanpackages (Garde ta logique d'origine)
if [ "$(ls -A debs 2>/dev/null)" ]; then
    echo "[*] Scanning local production binaries..."
    dpkg-scanpackages -m debs > Packages
    
    # 4. Compression simultanée multi-format requise pour Cydia/APT
    echo "[*] Generating compressed database extensions..."
    bzip2 -k Packages
    gzip -9fk Packages
    echo "[V] Remote repository indexes compiled successfully!"
else
    echo "[!] Warning: No .deb packages found inside /debs directory."
    # Crée des fichiers vides pour éviter que Cydia ne renvoie une erreur 404
    touch Packages Packages.bz2 Packages.gz
fi
