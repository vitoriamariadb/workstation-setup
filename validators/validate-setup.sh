#!/bin/bash
# Validador de estrutura do workstation-setup
# Verifica se todos os componentes essenciais estao presentes

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ERRORS=0
WARNINGS=0

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${NC} $1"; WARNINGS=$((WARNINGS + 1)); }
fail() { echo -e "${RED}[ERRO]${NC} $1"; ERRORS=$((ERRORS + 1)); }

echo "=== VALIDACAO DO WORKSTATION-SETUP ==="
echo "Diretorio: $REPO_DIR"
echo ""

# 1. Verificar diretorios obrigatorios
echo "--- Diretorios ---"
for dir in core functions scripts agents templates validators; do
    if [ -d "$REPO_DIR/$dir" ]; then
        ok "Diretorio $dir/ existe"
    else
        fail "Diretorio $dir/ ausente"
    fi
done

# 2. Verificar subdiretorios de agentes
echo ""
echo "--- Agentes ---"
for agent_dir in provider-a provider-b; do
    if [ -d "$REPO_DIR/agents/$agent_dir" ]; then
        ok "Agente $agent_dir/ existe"
        if [ -f "$REPO_DIR/agents/$agent_dir/aliases.zsh" ]; then
            ok "  aliases.zsh presente"
        else
            warn "  aliases.zsh ausente em $agent_dir/"
        fi
    else
        warn "Agente $agent_dir/ ausente"
    fi
done

# 3. Verificar arquivos core
echo ""
echo "--- Core ---"
for file in core/aliases.zsh core/env.zsh core/zshrc core/functions.zsh; do
    if [ -f "$REPO_DIR/$file" ]; then
        ok "$file presente"
    else
        fail "$file ausente"
    fi
done

# 4. Verificar funcoes essenciais
echo ""
echo "--- Funcoes ---"
essential_functions=(
    "functions/_helpers.zsh"
    "functions/navegacao.zsh"
    "functions/busca.zsh"
    "functions/conjurar.zsh"
)
for file in "${essential_functions[@]}"; do
    if [ -f "$REPO_DIR/$file" ]; then
        ok "$file presente"
    else
        warn "$file ausente"
    fi
done

# 5. Verificar scripts
echo ""
echo "--- Scripts ---"
for file in scripts/analisador-dados.py scripts/universal-sanitizer.py scripts/ritual-da-aurora.sh; do
    if [ -f "$REPO_DIR/$file" ]; then
        ok "$file presente"
    else
        warn "$file ausente"
    fi
done

# 6. Verificar templates
echo ""
echo "--- Templates ---"
for file in templates/secrets.zsh.example templates/git-profiles.conf.example; do
    if [ -f "$REPO_DIR/$file" ]; then
        ok "$file presente"
    else
        warn "$file ausente"
    fi
done

# 7. Verificar documentacao
echo ""
echo "--- Documentacao ---"
for file in README.md LICENSE; do
    if [ -f "$REPO_DIR/$file" ]; then
        ok "$file presente"
    else
        warn "$file ausente"
    fi
done

# 8. Verificar dependencias do sistema
echo ""
echo "--- Dependencias ---"
for cmd in git python3 fzf rsync; do
    if command -v "$cmd" &> /dev/null; then
        ok "$cmd instalado ($(command -v "$cmd"))"
    else
        warn "$cmd nao encontrado"
    fi
done

# 9. Verificar por emojis no repositorio
echo ""
echo "--- Sanitizacao ---"
emoji_count=$(grep -rP '[\x{1F600}-\x{1F64F}\x{1F300}-\x{1F5FF}\x{1F680}-\x{1F6FF}\x{2600}-\x{26FF}\x{2700}-\x{27BF}]' "$REPO_DIR" --include="*.zsh" --include="*.sh" --include="*.py" --include="*.md" 2>/dev/null | wc -l || echo "0")
if [ "$emoji_count" -eq 0 ]; then
    ok "Nenhum emoji encontrado"
else
    warn "$emoji_count linha(s) com emojis encontrada(s)"
fi

# Resultado final
echo ""
echo "=== RESULTADO ==="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}Validacao completa: sem erros, sem avisos.${NC}"
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}Validacao completa: $WARNINGS aviso(s), sem erros.${NC}"
else
    echo -e "${RED}Validacao falhou: $ERRORS erro(s), $WARNINGS aviso(s).${NC}"
    exit 1
fi

# "A qualidade nao e um ato, e um habito." -- Aristoteles
