# Objetos do pacote ZCHM

Todos os objetos do repositório, na ordem em que aparecem no curso.

| Objeto | Tipo | Aula em que nasce | Para que serve |
|---|---|---|---|
| `ZCHM` | Pacote | 00.5 | Pacote do app Gestão de Chamados; todos os objetos do curso ficam nele |
| `ZCHM_DEMO` | Tabela | 01.5 | Tabela de demonstração usada como entrada do assistente *Generate ABAP Repository Objects*; não faz parte do app de chamados |
| `ZCHM_CHAMADO` | Tabela | 02.1 | Tabela de chamados: chave UUID, número legível, dados do chamado e os cinco campos administrativos |
| `ZCL_CHM_CARGA` | Classe | 02.2 | Carga de dados de teste: apaga a tabela e grava os três chamados do curso; executa com F9 (`if_oo_adt_classrun`) |
| `ZR_Chamado` | CDS view entity (raiz) | 02.3 | View base do business object: lê `zchm_chamado` e dá os nomes de negócio aos campos |
| `ZI_ClienteVH` | CDS view entity | 02.4 | Ajuda de pesquisa de clientes: código e nome, lidos da view padrão `I_Customer` |
| `ZCHM_STATUS` | Domínio | 02.4 | Valores fixos do status do chamado: `A` Aberto, `E` Encerrado |
| `ZI_StatusVH` | CDS view entity | 02.4 | Ajuda de pesquisa de status: lê os valores fixos do domínio `ZCHM_STATUS` |
| `ZCHM_PRIORIDADE` | Domínio | 02.4 (exercício) | Valores fixos da prioridade: `A` Alta, `M` Média, `B` Baixa |
| `ZI_PrioridadeVH` | CDS view entity | 02.4 (exercício) | Ajuda de pesquisa de prioridade: lê os valores fixos do domínio `ZCHM_PRIORIDADE` |
| `ZC_Chamado` | CDS projection view (raiz) | 03.1 | Projeção de `ZR_Chamado` para o app de suporte, com `provider contract transactional_query` |
| `ZUI_CHAMADO` | Service definition | 03.2 | Diz o que entra no serviço: expõe `ZC_Chamado` com o nome público `Chamado` |
| `ZUI_CHAMADO_O4` | Service binding (OData V4 - UI) | 03.2 | Publica `ZUI_CHAMADO` como OData V4 de UI e libera o preview do app; depois do pull é preciso publicar (botão *Publish*) |
| `ZC_Chamado` | Metadata extension | 03.3 | Anotações de tela da projeção: colunas, filtros e cabeçalho da lista; seções da object page a partir da 03.4 |
| `ZCHM` | Classe de objetos de autorização | 03.6 | Agrupa os objetos de autorização do app |
| `ZCHM_CLI` | Campo de autorização | 03.6 | Campo de cliente (elemento de dados `KUNNR`) usado no objeto de autorização `ZCHM_CLI` |
| `ZCHM_CLI` | Objeto de autorização | 03.6 | Cliente (`ZCHM_CLI`) e atividade (`ACTVT`, 03 = exibir); o papel de cada usuário na PFCG diz quais clientes ele enxerga |
| `ZR_Chamado` | Access control (DCL) | 03.6 | Só passa a linha cujo cliente está na autorização `ZCHM_CLI` do usuário |
| `ZC_Chamado` | Access control (DCL) | 03.6 | A projeção herda as condições de `ZR_Chamado` (`inheriting conditions from entity`) |
| `ZR_Chamado` | Behavior definition (managed) | 04.1 | Comportamento do business object: `create`, `update`, `delete`, chave UUID gerada pelo framework, campos somente leitura e o mapping para `zchm_chamado`; com draft a partir da 05.2 |
| `ZBP_R_CHAMADO` | Classe (behavior pool) | 04.1 | Onde mora a lógica do business object; classe local handler `lhc_Chamado`; até o M05 só com o método de autorização vazio, no M06 ganha as determinations, validations, actions e o feature control |
| `ZC_Chamado` | Behavior definition (projeção) | 04.1 | Expõe ao serviço, com `use`, as operações definidas na BDEF base |
| `ZCHM_CHAMADO_D` | Tabela (draft) | 05.2 | Tabela de rascunho de `ZR_Chamado`: um campo por elemento da view, com os nomes da CDS, mais o include administrativo `sych_bdl_draft_admin_inc`; gerada pelo ADT (Ctrl+1 na BDEF), nunca editada à mão |
