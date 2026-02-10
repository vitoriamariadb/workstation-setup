# Instalacao

## Pre-requisitos

### Obrigatorios

- **zsh** - Shell principal
- **git** - Controle de versao
- **python3** - Scripts auxiliares

### Recomendados

- **fzf** - Menu interativo (usado pelo conjurar)
- **rsync** - Sincronizacao remota e local
- **tree** - Visualizacao de arvore de diretorios

### Instalacao das dependencias (Debian/Ubuntu/Pop!_OS)

```bash
sudo apt update
sudo apt install -y zsh git python3 fzf rsync tree
```

## Instalacao Rapida

```bash
git clone <repo-url> ~/workstation-setup
cd ~/workstation-setup
bash install.sh
```

## Instalacao com Preview

```bash
bash install.sh --dry-run
```

Mostra o que seria feito sem modificar nada.

## Instalacao Forcada

```bash
bash install.sh --force
```

Sobrescreve symlinks e configuracoes existentes.

## Pos-instalacao

### 1. Configurar ZDOTDIR

Adicione ao `~/.zshrc`:

```bash
export ZDOTDIR="$HOME/.config/zsh"
[ -f "$ZDOTDIR/zshrc" ] && source "$ZDOTDIR/zshrc"
```

### 2. Copiar templates

```bash
cp templates/secrets.zsh.example ~/.config/zsh/secrets.zsh
cp templates/git-profiles.conf.example ~/.config/zsh/git-profiles.conf
```

Edite os arquivos copiados com seus dados reais.

### 3. Recarregar

```bash
source ~/.zshrc
```

### 4. Validar

```bash
bash validators/validate-setup.sh
```

## Desinstalacao

Para remover, delete os symlinks criados em `~/.config/zsh/`.
O backup da configuracao anterior esta em `~/.config/zsh-backup-*`.

*"A preparacao e a chave para o sucesso." -- Alexander Graham Bell*
