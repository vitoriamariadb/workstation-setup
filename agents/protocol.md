# Protocolo Geral de Agentes

## Visao Geral

O sistema de agentes permite integrar diferentes provedores de CLI
com controle de quota, protecao de contexto e aliases padronizados.

## Estrutura

```
agents/
  protocol.md           # Este arquivo
  provider-a/           # Agente A com sistema de quota
    aliases.zsh
    guard.sh
    quota-manager.sh
    install-quota.sh
    docs/
  provider-b/           # Agente B com funcoes de produtividade
    aliases.zsh
    PROTOCOL.md
    AGENTS.md
```

## Principios Comuns

1. **Anonimato** - Nenhum agente deve deixar rastros identificaveis no codigo
2. **Economia** - Minimizar consumo de tokens/requests por interacao
3. **PT-BR** - Toda comunicacao em portugues tecnico
4. **Zero emojis** - Em codigo, commits, documentacao e respostas
5. **Offline First** - Funcionar sem dependencia de APIs externas quando possivel

## Adicionando Novo Agente

1. Criar diretorio `agents/<nome-do-provider>/`
2. Criar `aliases.zsh` com funcoes wrapper
3. Criar documentacao (PROTOCOL.md ou README.md)
4. Registrar no `protocol.md`

## Convencoes de Nomenclatura

- Diretorios: `kebab-case`
- Funcoes shell: `provider-nome-acao`
- Aliases: abreviacoes curtas (2-3 caracteres)
- Variaveis: `PROVIDER_NOME_VARIAVEL`

*"A uniformidade e a condicao de toda lei." -- Montesquieu*
