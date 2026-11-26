# Objetos do pacote ZCHM

Todos os objetos do repositório, na ordem em que aparecem no curso.

| Objeto | Tipo | Aula em que nasce | Para que serve |
|---|---|---|---|
| `ZCHM` | Pacote | 00.5 | Pacote do app Gestão de Chamados; todos os objetos do curso ficam nele |
| `ZCHM_DEMO` | Tabela | 01.5 | Tabela de demonstração usada como entrada do assistente *Generate ABAP Repository Objects*; não faz parte do app de chamados |
| `ZCHM_CHAMADO` | Tabela | 02.1 | Tabela de chamados: chave UUID, número legível, dados do chamado e os cinco campos administrativos |
| `ZCL_CHM_CARGA` | Classe | 02.2 | Carga de dados de teste: apaga as tabelas e grava os três chamados do curso e, a partir da 07.1, os quatro apontamentos; executa com F9 (`if_oo_adt_classrun`) |
| `ZR_Chamado` | CDS view entity (raiz) | 02.3 | View base do business object: lê `zchm_chamado` e dá os nomes de negócio aos campos; a partir da 07.1 declara a composição `_Apontamentos` |
| `ZI_ClienteVH` | CDS view entity | 02.4 | Ajuda de pesquisa de clientes: código e nome, lidos da view padrão `I_Customer` |
| `ZCHM_STATUS` | Domínio | 02.4 | Valores fixos do status do chamado: `A` Aberto, `E` Encerrado |
| `ZI_StatusVH` | CDS view entity | 02.4 | Ajuda de pesquisa de status: lê os valores fixos do domínio `ZCHM_STATUS` |
| `ZCHM_PRIORIDADE` | Domínio | 02.4 (exercício) | Valores fixos da prioridade: `A` Alta, `M` Média, `B` Baixa |
| `ZI_PrioridadeVH` | CDS view entity | 02.4 (exercício) | Ajuda de pesquisa de prioridade: lê os valores fixos do domínio `ZCHM_PRIORIDADE` |
| `ZC_Chamado` | CDS projection view (raiz) | 03.1 | Projeção de `ZR_Chamado` para o app de suporte, com `provider contract transactional_query`; a partir da 07.1 redireciona `_Apontamentos` para `ZC_Apontamento` |
| `ZUI_CHAMADO` | Service definition | 03.2 | Diz o que entra no serviço: expõe `ZC_Chamado` com o nome público `Chamado`; a partir da 07.3 expõe também `ZC_Apontamento` como `Apontamento` |
| `ZUI_CHAMADO_O4` | Service binding (OData V4 - UI) | 03.2 | Publica `ZUI_CHAMADO` como OData V4 de UI e libera o preview do app; depois do pull é preciso publicar (botão *Publish*) |
| `ZC_Chamado` | Metadata extension | 03.3 | Anotações de tela da projeção: colunas, filtros e cabeçalho da lista; seções da object page a partir da 03.4; seção com a tabela de apontamentos a partir da 07.3 |
| `ZCHM` | Classe de objetos de autorização | 03.6 | Agrupa os objetos de autorização do app |
| `ZCHM_CLI` | Campo de autorização | 03.6 | Campo de cliente (elemento de dados `KUNNR`) usado no objeto de autorização `ZCHM_CLI` |
| `ZCHM_CLI` | Objeto de autorização | 03.6 | Cliente (`ZCHM_CLI`) e atividade (`ACTVT`, 03 = exibir); o papel de cada usuário na PFCG diz quais clientes ele enxerga |
| `ZR_Chamado` | Access control (DCL) | 03.6 | Só passa a linha cujo cliente está na autorização `ZCHM_CLI` do usuário |
| `ZC_Chamado` | Access control (DCL) | 03.6 | A projeção herda as condições de `ZR_Chamado` (`inheriting conditions from entity`) |
| `ZR_Chamado` | Behavior definition (managed) | 04.1 | Comportamento do business object: `create`, `update`, `delete`, chave UUID gerada pelo framework, campos somente leitura e o mapping para `zchm_chamado`; com draft a partir da 05.2; `authorization master ( global, instance )` a partir da 09.2 e `update ( precheck )` a partir da 09.4; `with additional save with full data` na 10.2; na 10.3 sai o `persistent table` do chamado e entra `with unmanaged save with full data`; a partir da 07.2 traz também o bloco do filho `ZR_Apontamento` (alias `Apontamento`), criado pela associação `_Apontamentos` |
| `ZBP_R_CHAMADO` | Classe (behavior pool) | 04.1 | Onde mora a lógica do business object; classe local handler `lhc_Chamado`; até o M05 só com o método de autorização vazio, no M06 ganha as determinations, validations, actions e o feature control; a autorização global (`get_global_authorizations`) entra na 09.2 e a de instância (só o responsável ou o gestor encerra) na 09.3; o precheck do update (`precheck_update`, prioridade Alta só para o gestor) na 09.4; a classe local saver `lsc_ZR_Chamado` entra na 10.1, com `finalize` e `check_before_save` redefinidos só para o depurador ter onde parar; na 10.2 a saver ganha o `save_modified`, que grava o log em `zchm_log`; na 10.3 o `save_modified` passa a entregar os chamados à classe legada `ZCL_CHM_LOG_LEGADO`; a partir da 07.5 tem também a classe local `lhc_Apontamento` (total de horas e, na 07.6, as validações do filho) |
| `ZC_Chamado` | Behavior definition (projeção) | 04.1 | Expõe ao serviço, com `use`, as operações definidas na BDEF base; a partir da 07.2 inclui o bloco de `ZC_Apontamento` e `use association` |
| `ZCHM_CHAMADO_D` | Tabela (draft) | 05.2 | Tabela de rascunho de `ZR_Chamado`: um campo por elemento da view, com os nomes da CDS, mais o include administrativo `sych_bdl_draft_admin_inc`; gerada pelo ADT (Ctrl+1 na BDEF), nunca editada à mão |
| `ZCHM_MSG` | Classe de mensagens | 06.4 | Textos das mensagens do app: 001 título obrigatório, 002 cliente inexistente; a 003 (motivo do encerramento) entra na 06.6; 010 (horas maiores que zero) e 011 (data não futura) entram na 07.6; 020 (prioridade Alta só para o gestor) na 09.4 |
| `ZA_MotivoEncerramento` | CDS abstract entity | 06.6 | Estrutura do parâmetro da action `encerrarComMotivo`: um campo, `Motivo`; o Fiori elements monta o diálogo a partir dela |
| `ZCHM_APONT` | Tabela | 07.1 | Tabela de apontamentos de horas: chave UUID própria, `chamado_uuid` com a chave do chamado (pai), data, horas, descrição e os cinco campos administrativos; já vem pronta na aula |
| `ZR_Apontamento` | CDS view entity (filho) | 07.1 | View base do apontamento: lê `zchm_apont` e aponta para o chamado com `association to parent` |
| `ZC_Apontamento` | CDS projection view (filho) | 07.1 | Projeção de `ZR_Apontamento` para o app; `_Chamado` redirecionada para `ZC_Chamado` |
| `ZCHM_APONT_D` | Tabela (draft) | 07.2 | Tabela de rascunho de `ZR_Apontamento`, gerada pelo ADT (Ctrl+1 na BDEF); a aula 07.4 abre a tabela e explica o `with draft` das associações |
| `ZC_Apontamento` | Metadata extension | 07.3 | Anotações de tela do apontamento: colunas da tabela dentro do chamado (`@UI.lineItem`) e campos da página de detalhe (`@UI.identification`) |
| `ZCL_CHM_EML_DEMO` | Classe | 08.1 | Classe de console do módulo de EML (`if_oo_adt_classrun`, executa com F9): o método `main` é reescrito a cada aula do M08 — leitura (08.1), tipos derivados (08.2), create e update (08.3), create by association e deep create (08.4), actions (08.5), commit com tratamento de erro (08.6) e a prova do `IN LOCAL MODE` (08.7) |
| `ZCHM_CHAM` | Objeto de autorização | 09.2 | Autorização de escrita do app, só com o campo de atividade `ACTVT`: 01 = criar, 06 = excluir, 70 = administrar (o gestor); na gravação o objeto, os papéis e o usuário de teste `ANALISTA` são tarefa de Basis — o objeto vem no repositório, os papéis (PFCG) não |
| `ZCHM_LOG` | Tabela | 10.2 | Log de alteração do chamado: chave UUID própria, UUID do chamado, operação (`C` criação, `U` alteração, `D` exclusão), status naquele momento, usuário e hora (`utclong`); já vem pronta na aula; gravada pelo `save_modified` na 10.2 e pela classe legada a partir da 10.3 |
| `ZCL_CHM_LOG_LEGADO` | Classe | 10.3 | Código do curso que faz o papel do legado: `gravar` regrava os chamados em `zchm_chamado` e insere uma linha por chamado em `zchm_log`; `excluir` apaga o chamado e registra a operação `D`; não faz `COMMIT WORK`; preenche a chave UUID e os campos administrativos quando chegam vazios (caso do BO unmanaged das aulas 10.4 a 10.7); já vem pronta na aula |
| `ZR_ChamadoU` | CDS view entity (raiz) | 10.4 | View raiz do business object unmanaged de exemplo: lê a mesma `zchm_chamado`, com poucos campos e o número do chamado (`ChamadoID`) como chave; já vem pronta na aula |
| `ZR_ChamadoU` | Behavior definition (unmanaged) | 10.4 | Comportamento do BO unmanaged: `create`, `update`, `delete`, `lock master`, sem `persistent table`, com o mapping para `zchm_chamado` |
| `ZBP_R_CHAMADOU` | Classe (behavior pool) | 10.4 | Behavior pool do BO unmanaged: handler `lhc_Chamado` (`create`, `update`, `delete`, `read`, `lock`) e saver `lsc_ZR_ChamadoU`; nasce com todos os métodos vazios; na 10.5 o `save` e o `cleanup` passam a chamar o buffer; na 10.6 os cinco métodos do handler são preenchidos (CRUD completo, leitura pelo buffer e bloqueio com `EZCHM_CHAMADO`) |
| `ZCL_CHM_TESTE_U` | Classe | 10.4 | Classe de console (`if_oo_adt_classrun`, executa com F9) que testa o BO unmanaged por EML; o método `main` muda a cada aula, da 10.4 à 10.7 |
| `ZCL_CHM_BUFFER` | Classe | 10.5 | Buffer transacional do BO unmanaged, só com métodos estáticos: guarda o que foi criado, alterado e excluído na interaction phase (`incluir`, `alterar`, `excluir`), responde às leituras olhando a memória antes do banco (`ler`), entrega tudo à classe legada no `save` (`gravar`) e se esvazia no `cleanup` (`limpar`) |
| `EZCHM_CHAMADO` | Objeto de bloqueio | 10.6 | Bloqueio clássico (enqueue) da tabela `zchm_chamado`, com o argumento `CHAMADO_UUID`; usado pelo método `lock` do BO unmanaged; já vem pronto na aula |
