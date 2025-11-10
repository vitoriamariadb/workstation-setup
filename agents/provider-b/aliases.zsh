#!/bin/zsh
# aliases_provider_b.zsh - Provider B CLI + Dracula Theme
# Pop!_OS 22.04+ | Uso intensivo
# Cores: https://draculatheme.com

# ============================================================================
# CORES DRACULA
# ============================================================================

# Cores ANSI para terminal
autoload -U colors && colors

RESET="\033[0m"
DRACULA_BG="\033[48;2;40;42;54m"
DRACULA_FG="\033[38;2;248;248;242m"
DRACULA_COMMENT="\033[38;2;98;114;164m"
DRACULA_CYAN="\033[38;2;139;233;253m"
DRACULA_GREEN="\033[38;2;80;250;123m"
DRACULA_ORANGE="\033[38;2;255;184;108m"
DRACULA_PINK="\033[38;2;255;121;198m"
DRACULA_PURPLE="\033[38;2;189;147;249m"
DRACULA_RED="\033[38;2;255;85;85m"
DRACULA_YELLOW="\033[38;2;241;250;140m"

# ============================================================================
# DIRETORIOS
# ============================================================================

PROVIDER_B_DIR="${ZDOTDIR:-$HOME/.config/zsh}/agents/provider-b"

# ============================================================================
# FUNCAO PRINCIPAL: pba (Provider B com permissoes)
# ============================================================================

# pba = provider-b com auto-accept
pba() {
    if ! command -v provider-b &> /dev/null; then
        echo -e "${DRACULA_RED}[ERRO]${RESET} Provider B CLI nao encontrado."
        return 1
    fi

    command provider-b "$@"
}

# ============================================================================
# ALIASES DE AUTENTICACAO
# ============================================================================

# Iniciar provider-b interativo
alias pb='pba'

# Setup
alias pb-setup='pba /setup'

# Status
alias pb-status='pba /status'

# ============================================================================
# ALIASES DE QUOTA
# ============================================================================

provider-b-quota() {
    echo -e "${DRACULA_PURPLE}=== PROVIDER B STATUS ===${RESET}"
    echo ""
    echo -e "${DRACULA_CYAN}Verifique seu uso no dashboard do provider.${RESET}"
}

alias pbq='provider-b-quota'

# ============================================================================
# FUNCOES DE PRODUTIVIDADE (Uso Intensivo)
# ============================================================================

# Refatorar arquivo
provider-b-refactor() {
    if [ -z "$1" ]; then
        echo -e "${DRACULA_RED}[ERRO]${DRACULA_FG} Uso: provider-b-refactor <arquivo> [instrucoes]"
        return 1
    fi

    local file="$1"
    shift
    local instructions="${*:-melhore este codigo mantendo a funcionalidade, adicione type hints, logging e error handling adequado}"

    if [ ! -f "$file" ]; then
        echo -e "${DRACULA_RED}[ERRO]${DRACULA_FG} Arquivo nao encontrado: $file"
        return 1
    fi

    echo -e "${DRACULA_CYAN}[REFACTOR]${DRACULA_FG} $file"
    pba "refatore o arquivo $file: $instructions. Codigo limpo, logging, type hints, zero emojis, PT-BR tecnico."
}

# Documentar arquivo
provider-b-doc() {
    if [ -z "$1" ]; then
        echo -e "${DRACULA_RED}[ERRO]${DRACULA_FG} Uso: provider-b-doc <arquivo>"
        return 1
    fi

    local file="$1"

    if [ ! -f "$file" ]; then
        echo -e "${DRACULA_RED}[ERRO]${DRACULA_FG} Arquivo nao encontrado: $file"
        return 1
    fi

    echo -e "${DRACULA_CYAN}[DOC]${DRACULA_FG} $file"
    pba "documente o arquivo $file adicionando docstrings completas, comentarios explicativos onde necessario, e um header com descricao do modulo. Mantenha o estilo tecnico PT-BR."
}

# Code review
provider-b-review() {
    if [ -z "$1" ]; then
        echo -e "${DRACULA_RED}[ERRO]${DRACULA_FG} Uso: provider-b-review <arquivo>"
        return 1
    fi

    local file="$1"

    if [ ! -f "$file" ]; then
        echo -e "${DRACULA_RED}[ERRO]${DRACULA_FG} Arquivo nao encontrado: $file"
        return 1
    fi

    echo -e "${DRACULA_CYAN}[REVIEW]${DRACULA_FG} $file"
    pba "faca um code review completo do arquivo $file. Identifique: bugs potenciais, code smells, violacoes de clean code, problemas de performance, e sugira melhorias especificas com exemplos de codigo."
}

# Gerar testes
provider-b-test() {
    if [ -z "$1" ]; then
        echo -e "${DRACULA_RED}[ERRO]${DRACULA_FG} Uso: provider-b-test <arquivo> [framework]"
        return 1
    fi

    local file="$1"
    local framework="${2:-pytest}"

    if [ ! -f "$file" ]; then
        echo -e "${DRACULA_RED}[ERRO]${DRACULA_FG} Arquivo nao encontrado: $file"
        return 1
    fi

    echo -e "${DRACULA_CYAN}[TEST]${DRACULA_FG} $file (framework: $framework)"
    pba "gere testes unitarios completos para o arquivo $file usando $framework. Inclua: testes para funcoes principais, casos de borda, mocks quando necessario, e fixtures reutilizaveis. Siga o padrao AAA (Arrange-Act-Assert)."
}

# Explicar codigo
provider-b-explain() {
    if [ -z "$1" ]; then
        echo -e "${DRACULA_RED}[ERRO]${DRACULA_FG} Uso: provider-b-explain <arquivo ou conceito>"
        return 1
    fi

    if [ -f "$1" ]; then
        echo -e "${DRACULA_CYAN}[EXPLAIN]${DRACULA_FG} $1"
        pba "explique de forma clara e tecnica o que este codigo faz, seu fluxo de execucao, e quaisquer padroes de design utilizados"
    else
        echo -e "${DRACULA_CYAN}[EXPLAIN]${DRACULA_FG} $1"
        pba "explique de forma tecnica e concisa: $1"
    fi
}

# Otimizar performance
provider-b-optimize() {
    if [ -z "$1" ]; then
        echo -e "${DRACULA_RED}[ERRO]${DRACULA_FG} Uso: provider-b-optimize <arquivo>"
        return 1
    fi

    local file="$1"

    if [ ! -f "$file" ]; then
        echo -e "${DRACULA_RED}[ERRO]${DRACULA_FG} Arquivo nao encontrado: $file"
        return 1
    fi

    echo -e "${DRACULA_CYAN}[OPTIMIZE]${DRACULA_FG} $file"
    pba "analise e otimize o arquivo $file para melhor performance. Identifique gargalos, algoritmos ineficientes, operacoes redundantes, e sugira otimizacoes especificas com benchmarks quando possivel."
}

# Debug assist
provider-b-debug() {
    if [ -z "$1" ]; then
        echo -e "${DRACULA_RED}[ERRO]${DRACULA_FG} Uso: provider-b-debug <arquivo> [descricao do erro]"
        return 1
    fi

    local file="$1"
    shift
    local error_desc="${*:-encontre e corrija bugs neste codigo}"

    if [ ! -f "$file" ]; then
        echo -e "${DRACULA_RED}[ERRO]${DRACULA_FG} Arquivo nao encontrado: $file"
        return 1
    fi

    echo -e "${DRACULA_CYAN}[DEBUG]${DRACULA_FG} $file"
    pba "debug o arquivo $file: $error_desc. Identifique a causa raiz, explique o problema, e forneca a correcao completa. Adicione logging apropriado para facilitar debug futuro."
}

# ============================================================================
# FUNCOES DE PROJETO
# ============================================================================

# Verificar anonimato no projeto
provider-b-check-anon() {
    local dir="${1:-.}"
    echo -e "${DRACULA_PURPLE}=== VERIFICACAO DE ANONIMATO ===${RESET}"
    echo -e "${DRACULA_COMMENT}Diretorio: $dir${RESET}"
    echo ""

    local patterns="provider-a|provider-b|anthropic|openai|gpt-[0-9]|gemini|copilot"
    local results=$(grep -rniE "$patterns" "$dir" --exclude-dir={node_modules,venv,target,.git,__pycache__,.tox,dist,build} --include="*.{py,js,ts,md,txt,rs,go,java,jsx,tsx}" 2>/dev/null | grep -viE "api_key|provider|model|config|client|engine|/login|/grant" || true)

    if [ -z "$results" ]; then
        echo -e "${DRACULA_GREEN}[OK]${DRACULA_FG} Nenhuma mencao encontrada"
        return 0
    else
        echo -e "${DRACULA_ORANGE}[AVISO]${DRACULA_FG} Possiveis mencoes encontradas:"
        echo "$results"
        return 1
    fi
}

# ============================================================================
# FUNCOES DE ATALHO RAPIDO
# ============================================================================

# Pergunta rapida
provider-b-ask() {
    pba "$@"
}

# Ver configuracao
provider-b-config() {
    echo -e "${DRACULA_PURPLE}=== PROVIDER B CONFIG ===${RESET}"
    echo ""
    echo -e "${DRACULA_CYAN}Diretorio:${RESET} $PROVIDER_B_DIR"
    echo ""
    echo -e "${DRACULA_COMMENT}Tema: Dracula${RESET}"
    echo ""
    echo -e "${DRACULA_CYAN}Comandos disponiveis:${RESET}"
    echo "  /login     - Login via navegador"
    echo "  /setup     - Configurar provider"
    echo "  /logout    - Deslogar"
    echo "  /status    - Status da sessao"
    echo "  /help      - Ajuda"
}

# "O codigo e propriedade de quem o executa, nao de quem o escreve." -- Anonimo
