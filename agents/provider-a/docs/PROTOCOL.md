# Protocolo do Provider A

## Principios

1. **Anonimato** - Nenhuma referencia a ferramentas especificas em codigo ou commits
2. **Economia** - Minimizar consumo de tokens por interacao
3. **Seguranca** - Guard impede leitura de arquivos excessivamente grandes
4. **Observabilidade** - Toda interacao e contabilizada no quota manager

## Fluxo de Execucao

```
1. Guard verifica quota disponivel (pre-check)
2. Guard valida tamanho de arquivos no contexto
3. Execucao do comando
4. Guard registra tokens estimados (post-check)
5. Quota manager atualiza contadores
```

## Limites Padrao

| Parametro | Valor |
|-----------|-------|
| MAX_FILE_SIZE_KB | 100 |
| MAX_CONTEXT_FILES | 5 |
| MAX_LINE_COUNT | 2000 |
| WARN_FILE_SIZE_KB | 50 |

## Reset Semanal

A quota e resetada automaticamente a cada 7 dias.
Para reset manual: `provider-a-quota-reset`

*"O excesso de informacao e a morte do conhecimento." -- Nassim Nicholas Taleb*
