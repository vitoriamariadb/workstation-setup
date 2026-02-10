# workstation-setup

Toolkit modular de configuracao ZSH para workstations Linux (Pop!_OS / Ubuntu).

Aliases em PT-BR, funcoes de produtividade, integracao com vault Obsidian,
sistema de agentes CLI com controle de quota e sanitizador universal.

## Funcionalidades

- **Aliases PT-BR** - Comandos naturais em portugues tecnico
- **Menu interativo (conjurar)** - FZF para descobrir aliases e funcoes
- **Git multi-identidade** - Alternancia automatica de perfis Git
- **Vault Obsidian** - Automacao de notas, sync e manutencao
- **Agentes CLI** - Wrappers com quota e guard para provedores
- **Sanitizador** - Pre-commit hook que remove emojis, secrets e artefatos
- **Diagnostico** - Monitoramento de sistema, GPU, disco e rede
- **Sincronizacao** - Rsync local/remoto com filtros inteligentes

## Instalacao

```bash
git clone <repo-url> ~/workstation-setup
cd ~/workstation-setup
bash install.sh
```

Para preview sem modificar nada:

```bash
bash install.sh --dry-run
```

## Estrutura

```
core/           # Configuracao base (aliases, env, zshrc)
functions/      # Funcoes modulares (git, navegacao, busca, vault)
scripts/        # Scripts auxiliares (Python, Bash)
agents/         # Sistema de agentes CLI (provider-a, provider-b)
templates/      # Templates de credenciais e configuracao
validators/     # Validadores de integridade
docs/           # Documentacao detalhada
```

Veja [docs/STRUCTURE.md](docs/STRUCTURE.md) para detalhes completos.

## Dependencias

| Pacote | Obrigatorio | Descricao |
|--------|-------------|-----------|
| zsh | Sim | Shell principal |
| git | Sim | Controle de versao |
| python3 | Sim | Scripts auxiliares |
| fzf | Recomendado | Menu interativo |
| rsync | Recomendado | Sincronizacao |
| tree | Opcional | Arvore de diretorios |

## Validacao

```bash
bash validators/validate-setup.sh
```

## Principios

- **Local First** - Funciona 100% offline
- **Zero emojis** - Em qualquer lugar
- **PT-BR tecnico** - Toda documentacao e comentarios
- **Modular** - Cada funcao em seu arquivo
- **Observavel** - Logging em todos os scripts

## Licenca

[GPLv3](LICENSE)

*"Primeiro, resolva o problema. Depois, escreva o codigo." -- John Johnson*
