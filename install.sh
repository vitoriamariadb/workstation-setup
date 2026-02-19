#!/bin/bash
# install.sh - Instala o workstation-setup criando symlinks
# Uso: bash install.sh [--dry-run] [--force]
# Dependencias: ln, mkdir, bash >= 4.0

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/.config/zsh"
BACKUP_DIR="$HOME/.config/zsh-backup-$(date +%Y%m%d_%H%M%S)"

DRY_RUN=0
FORCE=0

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        --force) FORCE=1 ;;
        --help)
            echo "Uso: bash install.sh [--dry-run] [--force]"
            echo ""
            echo "Opcoes:"
            echo "  --dry-run    Simula a instalacao sem modificar nada"
            echo "  --force      Sobrescreve symlinks existentes sem perguntar"
            echo "  --help       Mostra esta ajuda"
            exit 0
            ;;
        *) echo "Flag desconhecida: $arg"; exit 1 ;;
    esac
done

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

ok() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${NC} $1"; }
fail() { echo -e "${RED}[ERRO]${NC} $1"; }
info() { echo -e "${CYAN}[INFO]${NC} $1"; }

echo "=== INSTALACAO DO WORKSTATION-SETUP ==="
echo "Origem:  $SCRIPT_DIR"
echo "Destino: $TARGET_DIR"
echo ""

# 1. Verificar dependencias
echo "--- Verificando dependencias ---"
MISSING=0
for cmd in git python3 fzf rsync; do
    if command -v "$cmd" &> /dev/null; then
        ok "$cmd encontrado"
    else
        warn "$cmd nao encontrado (recomendado)"
        MISSING=$((MISSING + 1))
    fi
done
echo ""

if [ $MISSING -gt 0 ]; then
    warn "$MISSING dependencia(s) ausente(s). A instalacao continuara, mas algumas funcoes podem nao funcionar."
    echo ""
fi

# 2. Backup de configuracao existente
if [ -d "$TARGET_DIR" ] && [ ! -L "$TARGET_DIR" ]; then
    echo "--- Backup da configuracao existente ---"
    if [ $DRY_RUN -eq 1 ]; then
        info "[DRY-RUN] Faria backup de $TARGET_DIR para $BACKUP_DIR"
    else
        mkdir -p "$BACKUP_DIR"
        # Copiar apenas arquivos, nao symlinks
        find "$TARGET_DIR" -maxdepth 1 -type f -exec cp {} "$BACKUP_DIR/" \; 2>/dev/null || true
        ok "Backup criado em $BACKUP_DIR"
    fi
    echo ""
fi

# 3. Criar diretorio destino
if [ ! -d "$TARGET_DIR" ]; then
    if [ $DRY_RUN -eq 1 ]; then
        info "[DRY-RUN] Criaria diretorio $TARGET_DIR"
    else
        mkdir -p "$TARGET_DIR"
        ok "Diretorio criado: $TARGET_DIR"
    fi
fi

# 4. Criar symlinks
echo "--- Criando symlinks ---"

create_symlink() {
    local source="$1"
    local target="$2"

    if [ $DRY_RUN -eq 1 ]; then
        info "[DRY-RUN] $target -> $source"
        return
    fi

    # Se ja existe e nao e symlink, fazer backup
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        if [ $FORCE -eq 0 ]; then
            warn "$target ja existe (nao e symlink). Use --force para sobrescrever."
            return
        fi
        mv "$target" "${target}.bak"
        warn "Backup: ${target}.bak"
    fi

    # Remover symlink antigo se existir
    if [ -L "$target" ]; then
        rm "$target"
    fi

    # Criar diretorio pai se necessario
    local parent_dir=$(dirname "$target")
    mkdir -p "$parent_dir"

    ln -sf "$source" "$target"
    ok "$target -> $source"
}

# Core
for file in "$SCRIPT_DIR"/core/*; do
    [ -f "$file" ] || continue
    create_symlink "$file" "$TARGET_DIR/$(basename "$file")"
done

# Functions
mkdir -p "$TARGET_DIR/functions" 2>/dev/null || true
for file in "$SCRIPT_DIR"/functions/*; do
    [ -f "$file" ] || continue
    create_symlink "$file" "$TARGET_DIR/functions/$(basename "$file")"
done

# Scripts
mkdir -p "$TARGET_DIR/scripts" 2>/dev/null || true
for file in "$SCRIPT_DIR"/scripts/*; do
    [ -f "$file" ] || continue
    create_symlink "$file" "$TARGET_DIR/scripts/$(basename "$file")"
done

# Agents
for agent_dir in "$SCRIPT_DIR"/agents/*/; do
    [ -d "$agent_dir" ] || continue
    local_name=$(basename "$agent_dir")
    mkdir -p "$TARGET_DIR/agents/$local_name" 2>/dev/null || true
    for file in "$agent_dir"*; do
        [ -f "$file" ] || continue
        create_symlink "$file" "$TARGET_DIR/agents/$local_name/$(basename "$file")"
    done
    # Subdiretorios (docs, etc)
    for subdir in "$agent_dir"*/; do
        [ -d "$subdir" ] || continue
        sub_name=$(basename "$subdir")
        mkdir -p "$TARGET_DIR/agents/$local_name/$sub_name" 2>/dev/null || true
        for file in "$subdir"*; do
            [ -f "$file" ] || continue
            create_symlink "$file" "$TARGET_DIR/agents/$local_name/$sub_name/$(basename "$file")"
        done
    done
done

echo ""

# 5. Tornar scripts executaveis
echo "--- Permissoes ---"
if [ $DRY_RUN -eq 0 ]; then
    find "$SCRIPT_DIR" -name "*.sh" -exec chmod +x {} \;
    ok "Scripts .sh marcados como executaveis"
else
    info "[DRY-RUN] Marcaria scripts .sh como executaveis"
fi
echo ""

# 6. Verificar integracao com .zshrc
echo "--- Integracao ---"
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ]; then
    if grep -q "ZDOTDIR" "$ZSHRC" 2>/dev/null; then
        ok "ZDOTDIR ja configurado no .zshrc"
    else
        warn "Adicione ao seu .zshrc:"
        echo "  export ZDOTDIR=\"$TARGET_DIR\""
        echo "  [ -f \"\$ZDOTDIR/zshrc\" ] && source \"\$ZDOTDIR/zshrc\""
    fi
else
    warn ".zshrc nao encontrado. Crie com:"
    echo "  export ZDOTDIR=\"$TARGET_DIR\""
    echo "  [ -f \"\$ZDOTDIR/zshrc\" ] && source \"\$ZDOTDIR/zshrc\""
fi
echo ""

# Resultado
echo "=== INSTALACAO CONCLUIDA ==="
if [ $DRY_RUN -eq 1 ]; then
    info "Modo dry-run: nenhuma alteracao foi feita."
    echo "Execute sem --dry-run para aplicar."
else
    ok "Workstation-setup instalado com sucesso."
    echo ""
    echo "Proximo passo:"
    echo "  source ~/.zshrc"
fi

# "O comeco e a metade de toda acao." -- Proverbio grego
