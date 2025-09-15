# Provider A - Sistema de Agente com Quota

Sistema de controle de uso para o agente Provider A, incluindo:

- **aliases.zsh** - Wrappers seguros com verificacao de quota
- **guard.sh** - Guard que bloqueia arquivos/contextos excessivos
- **quota-manager.sh** - Gerenciador de quota semanal com limites configuraveis
- **install-quota.sh** - Script de instalacao do sistema de quota

## Instalacao

```bash
bash install-quota.sh
```

## Comandos Principais

| Comando | Descricao |
|---------|-----------|
| `provider-a-safe` | Wrapper seguro (recomendado) |
| `provider-a-quota` | Ver uso atual |
| `provider-a-estimate` | Estimar custo de arquivo |
| `provider-a-peek` | Preview sem consumir quota |
| `provider-a-report` | Relatorio semanal |
| `paa` | Execucao com permissoes completas |

## Estrutura

```
provider-a/
  aliases.zsh         # Aliases e funcoes
  guard.sh            # Guard de protecao
  quota-manager.sh    # Gerenciador de quota
  install-quota.sh    # Instalador
  docs/               # Documentacao
    PROTOCOL.md
    QUOTA-SYSTEM.md
    QUICKSTART.md
```

*"Medir e o primeiro passo para controlar e eventualmente melhorar." -- H. James Harrington*
