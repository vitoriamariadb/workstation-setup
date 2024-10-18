#!/bin/zsh

# Proposito: Gerenciar perfis git por diretorio de trabalho
__carregar_perfis_git() {
    local config_file="${ZDOTDIR:-$HOME/.config/zsh}/templates/git-profiles.conf"
    if [[ ! -f "$config_file" ]]; then
        config_file="${ZDOTDIR:-$HOME/.config/zsh}/git-profiles.conf"
    fi
    if [[ ! -f "$config_file" ]]; then
        __warn "git-profiles.conf nao encontrado. Usando git config global."
        return 1
    fi
    echo "$config_file"
}

__definir_contexto_git() {
    local user_name="$1"
    local user_email="$2"

    git config --local user.name "$user_name"
    git config --local user.email "$user_email"

    echo -e "  ${D_COMMENT}Contexto git:${D_RESET} ${D_CYAN}$user_name${D_RESET}"
}

__aplicar_contexto_git_automatico() {
    local config_file
    config_file=$(__carregar_perfis_git) || return 0

    local current_path="$(pwd)"
    local matched=false

    while IFS='=' read -r key value || [[ -n "$key" ]]; do
        [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)

        case "$key" in
            \[*\])
                local section="${key//[\[\]]/}"
                local section_path="" section_user="" section_email=""
                ;;
            path) section_path="$value" ;;
            user) section_user="$value" ;;
            email) section_email="$value" ;;
        esac

        if [[ -n "$section_path" && -n "$section_user" && -n "$section_email" ]]; then
            if [[ "$current_path" == *"$section_path"* ]]; then
                __definir_contexto_git "$section_user" "$section_email"
                matched=true
                return 0
            fi
            section_path="" section_user="" section_email=""
        fi
    done < "$config_file"

    if [[ "$matched" == false ]]; then
        local default_user="" default_email=""
        while IFS='=' read -r key value || [[ -n "$key" ]]; do
            [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)
            case "$key" in
                \[default\]) ;;
                user) [[ -z "$default_user" ]] && default_user="$value" ;;
                email) [[ -z "$default_email" ]] && default_email="$value" ;;
            esac
        done < "$config_file"
        if [[ -n "$default_user" && -n "$default_email" ]]; then
            __definir_contexto_git "$default_user" "$default_email"
        fi
    fi
}

git_info() {
    __header "IDENTIDADE GIT" "$D_PURPLE"

    __item "Nome" "$(git config --local user.name 2>/dev/null || echo '(global)')" "$D_COMMENT" "$D_FG"
    __item "Email" "$(git config --local user.email 2>/dev/null || echo '(global)')" "$D_COMMENT" "$D_FG"
    __item "Branch" "$(git branch --show-current 2>/dev/null)" "$D_COMMENT" "$D_CYAN"

    local remote_url=$(git remote get-url origin 2>/dev/null)
    __item "Remote" "${remote_url:-(nenhum)}" "$D_COMMENT" "$D_GREEN"

    local remote_proto="desconhecido"
    if [[ "$remote_url" == git@* || "$remote_url" == ssh://* ]]; then
        remote_proto="SSH"
    elif [[ "$remote_url" == https://* ]]; then
        remote_proto="HTTPS"
    fi
    __item "Auth" "$remote_proto" "$D_COMMENT" "$D_GREEN"

    echo ""
}

alias git_status='git_info'

__sinc_preservadora() {
    local nome_repo=$(basename "$(pwd)")
    local timestamp=$(date +'%Y-%m-%d_%Hh%M%S')
    local backup_root="_VERSAO_ANTIGA"
    local backup_dir="$backup_root/Backup_$timestamp"

    echo -e "  ${D_COMMENT}Sincronizando '${nome_repo}'...${D_RESET}"

    if ! git fetch --all -p -q; then
        __err "Falha ao buscar dados do remoto."
        return 1
    fi

    local upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    if [ -z "$upstream" ]; then
        __warn "Branch sem upstream. Nada a fazer."
        return 1
    fi

    if [ -n "$(git status --porcelain)" ]; then
        mkdir -p "$backup_dir"
        rsync -ax --exclude '.git' --exclude "$backup_root" . "$backup_dir"
        echo -e "  ${D_COMMENT}Backup:${D_RESET} ${D_CYAN}${backup_dir}${D_RESET}"
    fi

    git reset --hard "$upstream" -q
    git clean -fd -e "$backup_root" -q

    __ok "$nome_repo sincronizado."
}

# Proposito: Sincronizar repositorios selecionados via FZF (com backup de alteracoes)
# Uso: sincronizar_repositorio
sincronizar_repositorio() {
    __verificar_dependencias "git" "fzf" "rsync" || return 1

    local repos=$(find "$DEV_DIR" -maxdepth 4 -name ".git" -type d -prune | sed 's/\/\.git//' | sort)

    local selecao=$(echo "$repos" | fzf --multi --height=60% \
        --prompt="  Sincronizar > " \
        --header="  TAB para selecionar multiplos" \
        --color="bg+:#44475a,fg+:#f8f8f2,hl:#bd93f9,hl+:#ff79c6,pointer:#50fa7b,marker:#50fa7b,prompt:#bd93f9,header:#6272a4,border:#6272a4" \
        --preview 'git -C {} status -s')

    if [ -z "$selecao" ]; then echo -e "  ${D_COMMENT}Cancelado.${D_RESET}"; return 0; fi

    __header "SINCRONIZACAO" "$D_ORANGE"

    echo "$selecao" | while read -r repo_path; do
        cd "$repo_path" || continue
        __aplicar_contexto_git_automatico > /dev/null 2>&1
        __sinc_preservadora
    done
    echo ""
}

# Proposito: Sincronizar TODOS os repositorios com o remoto (com backup)
# Uso: sincronizar_todos_os_repositorios
sincronizar_todos_os_repositorios() {
    __verificar_dependencias "git" "rsync" || return 1

    __header "SINCRONIZACAO EM MASSA" "$D_RED"
    echo -e "  ${D_YELLOW}Arquivos locais nao versionados serao backupeados em '_VERSAO_ANTIGA/'.${D_RESET}"
    read -k 1 "reply?  Confirmar? (y/N) "
    echo ""

    if [[ "$reply" != "y" ]]; then echo -e "  ${D_COMMENT}Cancelado.${D_RESET}"; return 0; fi

    local repos=$(find "$DEV_DIR" -maxdepth 4 -name ".git" -type d -prune | sed 's/\/\.git//' | sort)

    echo "$repos" | while read -r repo_path; do
        cd "$repo_path" || continue
        __aplicar_contexto_git_automatico > /dev/null 2>&1
        __sinc_preservadora
    done

    echo ""
    __ok "Todos os repositorios processados."
    echo ""
}
