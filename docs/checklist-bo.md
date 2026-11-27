# Checklist de revisão de um business object

O checklist da aula 12.5. A revisão antes do transporte tem duas partes: o que a máquina encontra (ATC) e
o que só gente encontra (as decisões de projeto do business object). Passe pelas duas, nesta ordem.

## Antes do checklist: ATC

- [ ] ATC rodado no **pacote inteiro** (botão direito no pacote → *Run As* → *ABAP Test Cockpit*), não em um objeto só.
- [ ] Nenhum achado de prioridade 1 (erro) nem de prioridade 2 (aviso sério).
- [ ] Cada achado de prioridade 3 foi lido e decidido: corrigido, ou registrado por que fica como está.
- [ ] Nenhum achado escondido com pedido de exceção (*exemption*) ou comentário que silencia a verificação
      sem justificativa escrita. Se você não consegue explicar por que o achado está errado, é quase certo
      que ele está certo.

A lista de achados depende da variante de verificação configurada no seu sistema.

## 1. Modelo e serviço

- [ ] As views seguem as camadas e os nomes combinados: `ZR_` para a base (raiz e filhos), `ZC_` para a
      projeção de cada serviço, `ZI_` para ajudas de pesquisa e para a interface.
- [ ] A chave técnica é um UUID e o número legível é um campo comum (com `@ObjectModel.semanticKey` na projeção).
- [ ] Os campos administrativos têm as anotações semânticas (`@Semantics.user.createdBy`,
      `@Semantics.systemDateTime.lastChangedAt` e as demais); sem elas o framework não preenche.
- [ ] A view raiz tem access control (DCL) e `@AccessControl.authorizationCheck: #CHECK`; a projeção herda
      as condições da raiz.
- [ ] A projeção expõe só o que a tela usa; a service definition expõe só as entidades necessárias.
- [ ] As anotações de tela ficam na metadata extension, não na view.
- [ ] O service binding está publicado, e o tipo é o certo para quem consome: UI para o Fiori, Web API
      para outros sistemas.
- [ ] Outros programas usam a interface (`ZI_...TP`), nunca a view raiz; só a interface é liberada com contrato.

## 2. Comportamento

- [ ] `strict ( 2 )` ligado na behavior definition.
- [ ] `authorization master ( global, instance )` declarado, e os dois métodos de autorização
      **implementados de verdade**, não vazios; os filhos com `authorization dependent`.
- [ ] `lock master` na raiz, `lock dependent` nos filhos, e `etag` declarado (com draft, `total etag`).
- [ ] Todo campo calculado ou gerado pelo sistema está como `readonly`: chave, número, status, totais e
      campos administrativos.
- [ ] Numeração definida (`numbering : managed` para a chave UUID) e o número legível atribuído por uma
      determination.
- [ ] Toda validation `on save` aparece também na lista da `draft determine action Prepare`, senão o
      usuário só descobre o erro no último clique.
- [ ] Os gatilhos de determinations e validations (`create`, `field ...`) cobrem todos os campos que a
      regra lê.
- [ ] Actions com `features : instance` têm o `get_instance_features` correspondente; o que a tela mostra
      desabilitado o servidor também recusa.
- [ ] Operação que só consulta é `function`, não `action`.
- [ ] A projeção (`use ...`) expõe só as operações que aquele serviço deve oferecer.
- [ ] Efeito de um campo sobre outro declarado em `side effects`, para a tela se atualizar sozinha.

## 3. Código e entrega

- [ ] Os handlers recebem **várias chaves** e tratam todas de uma vez: uma leitura (`READ ENTITIES`) antes
      do laço, uma alteração (`MODIFY ENTITIES`) depois dele; nenhum acesso ao banco dentro de `LOOP`.
- [ ] Dentro do behavior pool, EML com `IN LOCAL MODE`; nenhum `COMMIT WORK` nem `COMMIT ENTITIES`.
- [ ] Gravação em banco só na fase de save (saver); nada de `INSERT`, `UPDATE` ou `DELETE` em handler.
- [ ] As mensagens vêm da classe de mensagens (`ZCHM_MSG`) e apontam o campo (`%element`); nada de texto
      fixo no código. Validations limpam e preenchem o `%state_area`.
- [ ] Toda falha registra a chave em `failed` **e** a mensagem em `reported`.
- [ ] Cada regra de negócio tem um teste ABAP Unit, os testes usam test doubles (não dependem dos dados
      do banco) e todos estão verdes.
- [ ] ATC sem prioridade 1 e 2.
- [ ] O app abre pelo tile do launchpad com um usuário que **não** é desenvolvedor, com a função certa.
