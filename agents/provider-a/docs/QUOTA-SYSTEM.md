# Sistema de Quota - Provider A

## Visao Geral

O sistema de quota controla o consumo semanal de tokens, prevenindo
uso excessivo e garantindo distribuicao equilibrada ao longo da semana.

## Componentes

### quota-manager.sh

Gerencia contadores de tokens e requests:

- `init` - Inicializar arquivo de quota
- `check` - Verificar uso atual
- `add <tokens>` - Registrar consumo
- `estimate <texto>` - Estimar tokens de um texto
- `pre-check` - Verificacao pre-execucao
- `reset` - Resetar contadores

### guard.sh

Camada de protecao que intercepta chamadas:

- Bloqueia leitura de arquivos > 100KB
- Avisa sobre contextos com > 3 arquivos
- Sugere alternativas (grep, head, tail)
- Permite bypass com variavel PROVIDER_A_FORCE

## Thresholds

| Nivel | Porcentagem | Acao |
|-------|-------------|------|
| Normal | 0-89% | Operacao livre |
| Aviso | 90-94% | Alerta no terminal |
| Critico | 95-99% | Confirmacao obrigatoria |
| Bloqueado | 100% | Execucao impedida |

## Arquivo de Quota

Localizado em `~/.config/zsh/agents/provider-a/.quota`:

```
week_start=2026-01-01
tokens_used=0
requests_count=0
```

*"O que nao se mede nao se gerencia." -- Peter Drucker*
