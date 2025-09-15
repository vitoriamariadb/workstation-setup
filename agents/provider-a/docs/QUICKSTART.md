# Quickstart - Provider A

## 1. Instalar

```bash
cd agents/provider-a
bash install-quota.sh
```

## 2. Ativar

Adicione ao `.zshrc`:

```bash
[ -f "$HOME/.config/zsh/agents/provider-a/aliases.zsh" ] && \
    source "$HOME/.config/zsh/agents/provider-a/aliases.zsh"
```

## 3. Verificar

```bash
source ~/.zshrc
provider-a-quota    # Ver status
provider-a-report   # Relatorio completo
```

## 4. Usar

```bash
provider-a-safe "sua pergunta"     # Wrapper seguro
provider-a-estimate arquivo.py     # Estimar custo
provider-a-peek arquivo.py         # Preview rapido
paa "sua pergunta"                 # Permissoes completas
```

## Atalhos

| Alias | Comando |
|-------|---------|
| `pq` | `provider-a-quota` |
| `pe` | `provider-a-estimate` |
| `pr` | `provider-a-report` |
| `paa` | Execucao com permissoes |

*"Comece onde voce esta. Use o que voce tem. Faca o que voce pode." -- Arthur Ashe*
