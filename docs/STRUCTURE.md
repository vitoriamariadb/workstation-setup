# Estrutura do Repositorio

```
workstation-setup/
  core/                     # Configuracao base do ZSH
    aliases.zsh             # Aliases em PT-BR
    env.zsh                 # Variaveis de ambiente e cores Dracula
    functions.zsh           # Loader de funcoes
    zshrc                   # Arquivo principal do ZSH

  functions/                # Funcoes modulares
    _helpers.zsh            # Helpers internos (prefixo _)
    arvore.zsh              # Arvore de diretorios com exportacao
    busca.zsh               # Busca inteligente de arquivos
    conjurar.zsh            # Menu FZF interativo
    controle-de-bordo.zsh   # Integracao com vault Obsidian
    diagnostico.zsh         # Diagnostico do sistema
    extrair.zsh             # Extracao de arquivos
    git-add.zsh             # Git add interativo
    git-contexto.zsh        # Alternancia de identidade Git
    git-recovery.zsh        # Recuperacao de commits
    hooks.zsh               # Instalacao de hooks Git
    limpeza.zsh             # Limpeza de caches e temporarios
    navegacao.zsh           # Navegacao rapida entre diretorios
    projeto.zsh             # Setup de novo projeto
    pulso.zsh               # Monitoramento de sistema
    remoto.zsh              # Conexoes remotas via rsync
    sistema.zsh             # Funcoes de sistema (reparo)
    sync-integrado.zsh      # Sincronizacao integrada do vault
    sync.zsh                # Sincronizacao de repos com vault
    vault-automation.zsh    # Automacao do vault Obsidian

  scripts/                  # Scripts auxiliares
    analisador-dados.py     # Analisador de datasets
    conjurar-helper.py      # Parser de aliases/funcoes para FZF
    processar-planilha.py   # Processador de planilhas (CSV/Excel/JSON)
    reconstrutor-helper.py  # Reconstrutor de arquivos a partir de markdown
    ritual-da-aurora.sh     # Setup de GPU e servicos essenciais
    universal-sanitizer.py  # Pre-commit hook sanitizador

  agents/                   # Sistema de agentes CLI
    protocol.md             # Protocolo geral
    provider-a/             # Agente A com quota
      aliases.zsh
      guard.sh
      quota-manager.sh
      install-quota.sh
      docs/
    provider-b/             # Agente B com produtividade
      aliases.zsh
      PROTOCOL.md
      AGENTS.md

  templates/                # Templates de configuracao
    secrets.zsh.example
    credentials.json.example
    service-account.json.example
    profiles.yml.example
    git-profiles.conf.example

  validators/               # Validadores
    validate-setup.sh

  docs/                     # Documentacao
    INSTALL.md
    STRUCTURE.md

  install.sh                # Instalador
  README.md                 # Documentacao principal
  LICENSE                   # GPLv3
  .gitignore
  .mailmap
```

## Convencoes

- **Nomes de arquivo**: `kebab-case` (exceto `_helpers.zsh` com prefixo)
- **Funcoes privadas**: Prefixo `__` (duplo underscore)
- **Linguagem**: PT-BR tecnico em toda documentacao e comentarios
- **Citacoes**: Todo arquivo termina com citacao de filosofo/estoico
- **Emojis**: Zero. Nenhum. Jamais.

*"A ordem e o prazer da razao, mas a desordem e o deleite da imaginacao." -- Paul Claudel*
