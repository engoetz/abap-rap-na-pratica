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
