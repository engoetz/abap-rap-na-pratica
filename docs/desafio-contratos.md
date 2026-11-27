# Desafio final: business object de Contratos

O projeto final do curso (aula 12.6). Um business object novo, do zero, sem roteiro: você já tem a caixa de
ferramentas completa, e só falta fazer de novo sem ninguém ditando o código.

## O cenário

Cada cliente tem **contratos de serviço**, com data de início, data de fim e status. Cada contrato tem
**itens**, que são os serviços contratados, com um valor mensal. É pai e filho de novo, mas com regras
diferentes das do chamado.

| | |
|---|---|
| Pacote | `ZCTR` (novo) |
| Entidade raiz | `ZR_Contrato` |
| Entidade filha | `ZR_ContratoItem` |
| Tabelas | `zctr_contrato` e `zctr_item` |

**Uma condição:** não vale copiar os objetos do pacote `ZCHM` e renomear. Crie cada objeto pelo assistente
e escreva o código; consulte o `ZCHM` só para tirar dúvida.

## As regras

1. Todo contrato nasce com um **número legível** e com o status **Em elaboração**.
2. A **data de fim** tem de ser maior que a data de início.
3. O **valor mensal** de cada item tem de ser maior que zero.
4. O **total do contrato** é a soma dos valores dos itens, recalculado sempre que um item muda.
5. Três ações:
   - **Ativar** — muda o status para Ativo. Só o gestor executa.
   - **Cancelar** — muda o status para Cancelado e pede um **motivo**.
   - **Renovar** — cria um contrato novo, copiando o atual com as datas do ano seguinte.
6. Contrato **ativo** não aceita mais alteração de itens.

Status sugeridos: `E` Em elaboração, `A` Ativo, `C` Cancelado.

## Ponto de partida

O primeiro passo a aula mostra: o pacote `ZCTR` e a tabela do contrato, com a chave UUID e os campos
administrativos.

```abap
@EndUserText.label : 'Contrato de serviço'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zctr_contrato {
  key client            : abap.clnt not null;
  key contrato_uuid     : sysuuid_x16 not null;
  contrato_id           : abap.numc(10);
  cliente               : abap.char(10);
  descricao             : abap.char(80);
  data_inicio           : abap.dats;
  data_fim              : abap.dats;
  @Semantics.amount.currencyCode : 'zctr_contrato.moeda'
  valor_total           : abap.curr(15,2);
  moeda                 : abap.cuky;
  status                : abap.char(1);
  created_by            : abp_creation_user;
  created_at            : abp_creation_tstmpl;
  last_changed_by       : abp_lastchange_user;
  last_changed_at       : abp_lastchange_tstmpl;
  local_last_changed_at : abp_locinst_lastchange_tstmpl;
}
```

A tabela de itens, `zctr_item`, é com você: `item_uuid` (chave), `contrato_uuid` (o pai), `servico`,
`valor_mensal`, `moeda` e os mesmos cinco campos administrativos.

## Dados de teste

Escreva uma classe de carga, como a `ZCL_CHM_CARGA` do curso, com pelo menos estes contratos. Os clientes
são os mesmos dos chamados de teste; a moeda é `BRL`.

| Contrato | Cliente | Descrição | Início | Fim | Status |
|---|---|---|---|---|---|
| 1 | 100017 | Suporte mensal ao faturamento | 01.01.2026 | 31.12.2026 | A |
| 2 | 100023 | Monitoramento de estoque | 01.07.2026 | 30.06.2027 | E |
| 3 | 100041 | Gestão de acessos | 01.01.2025 | 31.12.2025 | C |

| Contrato | Serviço | Valor mensal |
|---|---|---|
| 1 | Atendimento de chamados | 4.500,00 |
| 1 | Plantão de fechamento | 1.200,00 |
| 2 | Monitoramento de relatórios | 2.800,00 |
| 3 | Revisão de perfis | 900,00 |

Com esses itens, o total do contrato 1 é 5.700,00, o do contrato 2 é 2.800,00 e o do contrato 3 é 900,00.

## Cinco entregas, nesta ordem

Faça em entregas pequenas, na ordem do curso, e ative a cada passo. Cada entrega termina com o app
funcionando.

1. **Modelo e app somente leitura** — tabelas, carga de teste, views `ZR_`, projeção `ZC_`, service
   definition, service binding e metadata extension. O preview lista os contratos e abre o detalhe com os
   itens. (Módulos 02 e 03.)
2. **CRUD com draft, pai e filho** — behavior definition managed, behavior pool, tabelas de draft, criação
   de itens pela associação. (Módulos 04, 05 e 07.)
3. **Regras, ações e feature control** — número e status inicial, as duas validações, o total do contrato,
   Ativar, Cancelar com motivo, Renovar, e o bloqueio dos itens em contrato ativo. (Módulos 06 e 07.)
4. **Autorização e testes** — access control na view, autorização global e de instância (Ativar só para o
   gestor), um teste ABAP Unit por regra, com test doubles. (Módulos 03, 09 e 12.)
5. **Entrega** — ATC do pacote sem prioridade 1 e 2, revisão com o
   [checklist do curso](checklist-bo.md), app Fiori gerado e tile no launchpad. (Módulo 12.)

## Como saber que terminou

- [ ] O contrato novo recebe número e nasce Em elaboração, sem o usuário informar nenhum dos dois.
- [ ] Data de fim menor ou igual à de início não grava, e a mensagem aponta o campo.
- [ ] Item com valor zero ou negativo não grava.
- [ ] Incluir, alterar ou excluir um item atualiza o total do contrato na tela, sem recarregar.
- [ ] Ativar só funciona para o gestor; para os outros usuários a ação é recusada.
- [ ] Cancelar sem motivo não é aceito.
- [ ] Renovar cria um contrato novo, Em elaboração, com as datas um ano à frente e os mesmos itens.
- [ ] Em contrato ativo, a tela não deixa criar, alterar nem excluir item, e o servidor também recusa.
- [ ] Cada regra acima tem um teste ABAP Unit verde.
- [ ] ATC sem prioridade 1 e 2, e o tile abre o app no launchpad.

## Um aviso

O erro comum no projeto final é procurar código pronto cedo demais. Uma solução de referência serve só para
comparar, depois de fechar cada entrega. Ler código pronto dá a sensação de que você sabe; quem ensina de
verdade é a mensagem de erro na sua tela.

Quando terminar, publique o seu repositório e mostre o resultado.
