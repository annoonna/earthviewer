#!/bin/bash
# ============================================================
#  EarthViewer v0.2 - Vollständiges Installationsskript
#  Läuft auf: Debian / Kali Linux / Ubuntu
#  Aufruf:    sudo bash install.sh
# ============================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════╗"
echo "║       EarthViewer v0.2 - Installer               ║"
echo "║       Debian / Kali Linux / Ubuntu               ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

# --- Root-Check ---
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ Bitte als root ausführen: sudo bash install.sh${NC}"
    exit 1
fi

# Echter User (nicht root) für pip/venv ermitteln
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${YELLOW}► System-Pakete installieren (apt)...${NC}"
apt-get update -qq

apt-get install -y \
    tshark \
    wireshark \
    aircrack-ng \
    wireless-tools \
    net-tools \
    nmap \
    arp-scan \
    iw \
    tcpdump \
    libgl1 \
    libgl1-mesa-glx \
    libegl1 \
    libglib2.0-0 \
    libdbus-1-3 \
    python3-dev \
    python3-pip \
    python3-venv \
    build-essential \
    libssl-dev

echo -e "${GREEN}✅ System-Pakete installiert${NC}"

# --- tshark / dumpcap für Non-Root konfigurieren ---
echo -e "${YELLOW}► tshark Capabilities setzen...${NC}"
if [ -f /usr/bin/dumpcap ]; then
    chmod +x /usr/bin/dumpcap
    setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
    echo -e "${GREEN}✅ dumpcap Capabilities gesetzt${NC}"
else
    echo -e "${YELLOW}⚠️  /usr/bin/dumpcap nicht gefunden - tshark korrekt installiert?${NC}"
fi

# --- User zur wireshark-Gruppe hinzufügen ---
if id "$REAL_USER" &>/dev/null; then
    usermod -a -G wireshark "$REAL_USER" 2>/dev/null && \
        echo -e "${GREEN}✅ $REAL_USER zur Gruppe 'wireshark' hinzugefügt${NC}" || \
        echo -e "${YELLOW}⚠️  Gruppe 'wireshark' nicht gefunden${NC}"
fi

# --- Python Virtual Environment ---
VENV_DIR="$SCRIPT_DIR/myenv"
echo -e "${YELLOW}► Python Virtual Environment erstellen: $VENV_DIR${NC}"

if [ ! -d "$VENV_DIR" ]; then
    sudo -u "$REAL_USER" python3 -m venv "$VENV_DIR"
    echo -e "${GREEN}✅ venv erstellt${NC}"
else
    echo -e "${CYAN}ℹ️  venv existiert bereits, wird übersprungen${NC}"
fi

# --- pip Pakete installieren ---
echo -e "${YELLOW}► Python-Pakete installieren (pip)...${NC}"
sudo -u "$REAL_USER" "$VENV_DIR/bin/pip" install --upgrade pip -q
sudo -u "$REAL_USER" "$VENV_DIR/bin/pip" install -r "$SCRIPT_DIR/requirements.txt"

echo -e "${GREEN}✅ Python-Pakete installiert${NC}"

# --- Python Capabilities für Raw Sockets (Alternative zu sudo) ---
echo -e "${YELLOW}► Python Capabilities für Raw Sockets setzen...${NC}"
PYTHON_BIN="$VENV_DIR/bin/python3"
if [ -f "$PYTHON_BIN" ]; then
    setcap cap_net_raw,cap_net_admin+eip "$PYTHON_BIN"
    echo -e "${GREEN}✅ Python kann Raw Sockets ohne sudo nutzen${NC}"
fi

# --- GeoIP Hinweis ---
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}⚠️  MANUELLER SCHRITT: GeoIP2-Datenbank${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "   GeoLite2-City.mmdb kostenlos herunterladen:"
echo "   https://dev.maxmind.com/geoip/geolite2-free-geolocation-data"
echo "   → Datei in: $SCRIPT_DIR/data/ ablegen"
echo ""

# --- Fertig ---
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════╗"
echo "║   ✅  Installation abgeschlossen!                ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"
echo "Starten mit:"
echo "  source myenv/bin/activate && python main.py"
echo ""
echo -e "${YELLOW}⚠️  Neu anmelden damit wireshark-Gruppe aktiv wird!${NC}"
echo ""
