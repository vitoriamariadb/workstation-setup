#!/bin/bash

echo "=== INSTALANDO PROVIDER A QUOTA SYSTEM ==="
echo ""

AGENT_DIR="$HOME/.config/zsh/agents/provider-a"

echo "[1/4] Verificando arquivos necessarios..."
if [ ! -f "$AGENT_DIR/quota-manager.sh" ]; then
    echo "[ERRO] quota-manager.sh nao encontrado"
    exit 1
fi
if [ ! -f "$AGENT_DIR/guard.sh" ]; then
    echo "[ERRO] guard.sh nao encontrado"
    exit 1
fi
if [ ! -f "$AGENT_DIR/aliases.zsh" ]; then
    echo "[ERRO] aliases.zsh nao encontrado"
    exit 1
fi
echo "[OK] Todos os arquivos encontrados"
echo ""

echo "[2/4] Tornando scripts executaveis..."
chmod +x "$AGENT_DIR/quota-manager.sh"
chmod +x "$AGENT_DIR/guard.sh"
echo "[OK] Permissoes configuradas"
echo ""

echo "[3/4] Inicializando sistema de quota..."
bash "$AGENT_DIR/quota-manager.sh" init
bash "$AGENT_DIR/guard.sh" init
echo "[OK] Sistema inicializado"
echo ""

echo "[4/4] Verificando integracao..."
if [ -f "$AGENT_DIR/aliases.zsh" ]; then
    echo "[OK] Aliases prontos para source"
else
    echo "[AVISO] Aliases nao encontrados"
fi
echo ""

echo "=== INSTALACAO COMPLETA ==="
echo ""
echo "Para ativar, adicione ao seu .zshrc:"
echo "  [ -f \"\$HOME/.config/zsh/agents/provider-a/aliases.zsh\" ] && source \"\$HOME/.config/zsh/agents/provider-a/aliases.zsh\""
echo ""
echo "Comandos disponiveis:"
echo "  provider-a-quota       - Ver uso semanal"
echo "  provider-a-estimate    - Estimar custo de arquivo"
echo "  provider-a-peek        - Preview sem consumir quota"
echo "  provider-a-report      - Relatorio completo"
echo "  pq                     - Atalho para provider-a-quota"

# "A simplicidade e a sofisticacao suprema." -- Leonardo da Vinci
