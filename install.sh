#!/bin/bash
#
# 🔧 Smart Cache System - Installer
# Instalação automática do sistema de cache sob demanda
#
# Uso: curl -fsSL <URL> | bash
#    ou: git clone ... && cd smart-cache-system && ./install.sh
#
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     🧠 Smart Cache System — Installer                 ║${NC}"
echo -e "${BLUE}║     Cache Sob Demanda — Limpeza Automática            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Detecta diretório home
HOME_DIR="${HOME:-/data/data/com.termux/files/home}"
BIN_DIR="$HOME_DIR/.local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${YELLOW}[1/5]${NC} Configurando diretórios..."
mkdir -p "$BIN_DIR"
echo -e "  ✓ BIN_DIR: $BIN_DIR"

echo -e "${YELLOW}[2/5]${NC} Copiando scripts..."
cp -f "$SCRIPT_DIR/smart-cache.sh" "$BIN_DIR/smart-cache.sh"
chmod +x "$BIN_DIR/smart-cache.sh"
echo -e "  ✓ smart-cache.sh instalado"

# Copia wrappers opcionais
if [ -f "$SCRIPT_DIR/npm-smart" ]; then
    cp -f "$SCRIPT_DIR/npm-smart" "$BIN_DIR/npm-smart"
    chmod +x "$BIN_DIR/npm-smart"
    echo -e "  ✓ npm-smart instalado (opcional)"
fi

if [ -f "$SCRIPT_DIR/cargo-smart" ]; then
    cp -f "$SCRIPT_DIR/cargo-smart" "$BIN_DIR/cargo-smart"
    chmod +x "$BIN_DIR/cargo-smart"
    echo -e "  ✓ cargo-smart instalado (opcional)"
fi

if [ -f "$SCRIPT_DIR/gradle-smart" ]; then
    cp -f "$SCRIPT_DIR/gradle-smart" "$BIN_DIR/gradle-smart"
    chmod +x "$BIN_DIR/gradle-smart"
    echo -e "  ✓ gradle-smart instalado (opcional)"
fi

echo -e "${YELLOW}[3/5]${NC} limpando caches antigos..."
INITIAL_CLEAN=0

if [ -d "$HOME_DIR/.npm/_cacache" ]; then
    rm -rf "$HOME_DIR/.npm/_cacache"
    INITIAL_CLEAN=$((INITIAL_CLEAN + 1))
    echo -e "  ✓ .npm/_cacache removido"
fi

if [ -d "$HOME_DIR/.cargo/registry/src" ]; then
    rm -rf "$HOME_DIR/.cargo/registry/src" "$HOME_DIR/.cargo/registry/cache"
    INITIAL_CLEAN=$((INITIAL_CLEAN + 1))
    echo -e "  ✓ .cargo/registry removido"
fi

if [ -d "$HOME_DIR/.gradle/caches" ]; then
    rm -rf "$HOME_DIR/.gradle/caches"
    INITIAL_CLEAN=$((INITIAL_CLEAN + 1))
    echo -e "  ✓ .gradle/caches removido"
fi

if [ "$INITIAL_CLEAN" -gt 0 ]; then
    echo -e "  ${GREEN}✨ Caches antigos limpos!${NC}"
else
    echo -e "  ℹ️  Nenhum cache antigo encontrado"
fi

echo -e "${YELLOW}[4/5]${NC} Adicionando ao .bashrc..."

# Verifica se já existe o source
if grep -q "smart-cache.sh" "$HOME_DIR/.bashrc" 2>/dev/null; then
    echo -e "  ⚠️  smart-cache.sh já está no .bashrc"
else
    echo "" >> "$HOME_DIR/.bashrc"
    echo "# Smart Cache System - Auto-restore dependencies on demand" >> "$HOME_DIR/.bashrc"
    echo "source \"\$HOME/.local/bin/smart-cache.sh\"" >> "$HOME_DIR/.bashrc"
    echo -e "  ✓ .bashrc atualizado"
fi

echo -e "${YELLOW}[5/5]${NC} Carregando sistema..."
source "$BIN_DIR/smart-cache.sh" 2>/dev/null || true

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           ✅ INSTALAÇÃO CONCLUÍDA!                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Comandos disponíveis:${NC}"
echo -e "  • ${YELLOW}cache-status${NC}  — Ver status dos caches"
echo -e "  • ${YELLOW}cache-clean${NC}   — Limpar caches manualmente"
echo ""
echo -e "${BLUE}Como funciona:${NC}"
echo -e "  • Caches são limpos automaticamente ao iniciar o shell"
echo -e "  • Deps são restauradas sob demanda ao compilar"
echo -e "  • Suporte: NPM, Cargo (Rust), Gradle (Android)"
echo ""
echo -e "${YELLOW}Para desativar limpeza automática:${NC}"
echo -e "  Edite ~/.local/bin/smart-cache.sh e defina:"
echo -e "  ${RED}AUTO_CLEAN_ON_START=0${NC}"
echo ""
echo -e "Créditos: Lead Architect: Paçoca (@opassoca)"
echo -e " IA: Qwen3.5-397B-a17b"
echo ""

exit 0