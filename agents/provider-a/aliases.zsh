# Aliases para controle de uso do Provider A

# Proposito: Wrapper seguro para Provider A com quota guard
# Uso: provider-a-safe <args>
provider-a-safe() {
    bash "$HOME/.config/zsh/agents/provider-a/guard.sh" before || return 1

    local start_time=$(date +%s)
    command provider-a "$@"
    local exit_code=$?
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    local estimated_tokens=$((duration * 100))
    bash "$HOME/.config/zsh/agents/provider-a/guard.sh" after "$estimated_tokens"

    return $exit_code
}

# Proposito: Verificar quota de uso do Provider A
# Uso: provider-a-quota
provider-a-quota() {
    bash "$HOME/.config/zsh/agents/provider-a/quota-manager.sh" check
}

# Resetar quota (inicio de nova semana)
provider-a-quota-reset() {
    echo "[!] Tem certeza que quer resetar a quota? (y/n)"
    read -r response
    if [ "$response" = "y" ]; then
        bash "$HOME/.config/zsh/agents/provider-a/quota-manager.sh" reset
    fi
}

# Proposito: Estimar custo em tokens de um arquivo antes de enviar
# Uso: provider-a-estimate <arquivo>
provider-a-estimate() {
    if [ -z "$1" ]; then
        echo "Uso: provider-a-estimate <arquivo>"
        return 1
    fi

    bash "$HOME/.config/zsh/agents/provider-a/guard.sh" check-file "$1"
}

# Proposito: Preview rapido de arquivo (head/tail) sem consumir quota
# Uso: provider-a-peek <arquivo>
provider-a-peek() {
    if [ -z "$1" ]; then
        echo "Uso: provider-a-peek <arquivo>"
        return 1
    fi

    local file="$1"
    local lines=$(wc -l < "$file")
    local size=$(du -h "$file" | cut -f1)

    echo "=== PREVIEW: $file ==="
    echo "Tamanho: $size | Linhas: $lines"
    echo ""
    echo "--- INICIO (50 linhas) ---"
    head -n 50 "$file"
    echo ""
    echo "--- FIM (50 linhas) ---"
    tail -n 50 "$file"
    echo ""
    echo "[DICA] Use grep, sed ou awk para analises especificas sem consumir quota"
}

# Forcar comando ignorando limites (use com cuidado)
provider-a-force() {
    echo "[!] FORCANDO comando sem verificacoes!"
    PROVIDER_A_FORCE=1 command provider-a "$@"
}

# Proposito: Relatorio semanal de uso e dicas para economizar quota
# Uso: provider-a-report
provider-a-report() {
    echo "=== RELATORIO SEMANAL DE USO ==="
    bash "$HOME/.config/zsh/agents/provider-a/quota-manager.sh" check
    echo ""
    echo "=== DICAS PARA ECONOMIZAR ==="
    echo "1. Use grep/sed/awk para buscas rapidas"
    echo "2. Leia arquivos em secoes (head/tail)"
    echo "3. Use --skip-context quando nao precisar de historico"
    echo "4. Resuma contextos grandes antes de perguntar"
    echo "5. Evite ler arquivos > 100KB diretamente"
}

# Inicializar sistema de quota
provider-a-init() {
    bash "$HOME/.config/zsh/agents/provider-a/quota-manager.sh" init
    bash "$HOME/.config/zsh/agents/provider-a/guard.sh" init

    echo "[OK] Sistema de quota inicializado"
    echo "[OK] Guard configurado"
    echo ""
    echo "Comandos disponiveis:"
    echo "  provider-a-safe        - Wrapper seguro (recomendado)"
    echo "  provider-a-quota       - Ver uso atual"
    echo "  provider-a-estimate    - Estimar custo de arquivo"
    echo "  provider-a-peek        - Preview sem consumir quota"
    echo "  provider-a-report      - Relatorio semanal"
    echo "  provider-a-force       - Forcar (nao recomendado)"
}

# Proposito: Provider A com permissoes completas (--dangerously-skip-permissions)
# Uso: paa [args]
paa() {
    if ! command -v provider-a &> /dev/null; then
        echo "[ERRO] Provider A nao instalado."
        return 1
    fi

    bash "$HOME/.config/zsh/agents/provider-a/guard.sh" before || return 1

    local start_time=$(date +%s)
    command provider-a --dangerously-skip-permissions "$@"
    local exit_code=$?
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    local estimated_tokens=$((duration * 100))
    bash "$HOME/.config/zsh/agents/provider-a/guard.sh" after "$estimated_tokens"

    return $exit_code
}

# Proposito: Verificar quota do Provider A
# Uso: pq
alias pq='provider-a-quota'
# Proposito: Estimar custo de arquivo em tokens
# Uso: pe <arquivo>
alias pe='provider-a-estimate'
# Proposito: Preview de arquivo sem consumir quota
# Uso: pp-file <arquivo>
alias pp-file='provider-a-peek'
# Proposito: Relatorio de uso semanal do Provider A
# Uso: pr
alias pr='provider-a-report'

# "A frugalidade e filha da prudencia, irma da temperanca e mae da liberdade." -- Samuel Johnson
