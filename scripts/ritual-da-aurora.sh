#!/bin/bash
#

# Proposito: Ajusta a GPU e garante que servicos essenciais estejam rodando.
#            Logica: So pede senha (sudo) se encontrar algo desligado.
#

# Definicao de Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Iniciando o RITUAL DA AURORA...${NC}"

# --- FUNCAO INTELIGENTE (O Cerebro do Script) ---
# Verifica se o servico roda. Se sim, avisa. Se nao, tenta ligar (pedindo senha).
garantir_servico() {
    local servico=$1
    local nome=$2

    # Verifica status (silent) - Qualquer usuario pode ler isso
    if systemctl is-active --quiet "$servico"; then
        echo -e "${GREEN}-> $nome: Ja esta ativo e operante.${NC}"
    else
        echo -e "${YELLOW}-> $nome: ESTA DORMINDO! Solicitando permissao para acorda-lo...${NC}"

        # Aqui ele vai pedir a senha APENAS se entrar neste 'else'
        if sudo systemctl enable --now "$servico"; then
            echo -e "${GREEN}-> $nome: Acordado com sucesso.${NC}"
        else
            echo -e "${RED}-> $nome: Falha ao ligar (Senha recusada ou erro).${NC}"
        fi
    fi
}

# --- 1. CONFIGURACAO DE ENERGIA E GRAFICOS ---
echo -e "\n[1/4] Despertando o coracao da Nvidia (Modo Performance)..."
# Pequena pausa para garantir que o ambiente grafico carregou
sleep 3

if command -v nvidia-settings &> /dev/null; then
    # Configuracao de usuario (nao pede senha)
    nvidia-settings -a '[gpu:0]/GpuPowerMizerMode=1'

    # Configuracao de sistema (usa regra Polkit - nao pede senha)
    system76-power profile performance

    echo -e "${GREEN}-> GPU e Energia configurados para poder maximo.${NC}"
else
    echo -e "${YELLOW}-> Nvidia nao detectada. Pulando.${NC}"
fi

# --- 2. GUARDIAO DA MEMORIA ---
echo -e "\n[2/4] Verificando o Guardiao da Memoria..."
if command -v earlyoom &> /dev/null; then
    garantir_servico "earlyoom" "EarlyOOM"
else
    echo -e "${RED}ERRO: 'earlyoom' nao instalado.${NC}"
fi

# --- 3. CONECTIVIDADE E REDE ---
echo -e "\n[3/4] Verificando Portais de Conexao..."

# SSH
if command -v sshd &> /dev/null; then
    garantir_servico "ssh" "Mordomo SSH"
else
    echo -e "${RED}ERRO: SSH Server nao instalado.${NC}"
fi

# Avahi (mDNS)
if command -v avahi-daemon &> /dev/null; then
    garantir_servico "avahi-daemon" "Farol da Rede (mDNS)"
else
    echo -e "${RED}ERRO: Avahi Daemon nao instalado.${NC}"
fi

# --- 4. CONCLUSAO ---
echo -e "\n${GREEN}[4/4] Ritual concluido. O sistema esta pronto.${NC}"
sleep 3

# "A disciplina e a ponte entre metas e realizacoes." -- Jim Rohn
