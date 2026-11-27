# App Fiori "Gestão de Chamados" (`ui/chamados`)

Esta pasta é o lugar do projeto `chamados`, o app Fiori elements das aulas 12.3 e 12.4.

O projeto **não vem pronto no repositório**: ele é gerado na sua máquina pelo SAP Fiori tools, e o que o
gerador escreve depende da versão da ferramenta e do endereço do seu sistema. O que está aqui é o passo a
passo para você gerar o mesmo projeto. Nada dele é digitado à mão: as colunas, os filtros, os botões e a
página de detalhe continuam vindo das anotações da metadata extension e da behavior definition.

## Antes de começar

- Service binding `ZUI_CHAMADO_O4` **publicado** no S/4HANA (aula 03.2), no mandante em que você vai logar.
- [Node.js](https://nodejs.org) LTS instalado.
- VS Code com o pacote de extensões **SAP Fiori tools**.

No SAP Business Application Studio (BAS) o gerador e o projeto são os mesmos: crie um dev space do tipo
*SAP Fiori*. Para o BAS enxergar um sistema on-premise é preciso Cloud Connector e uma destination no BTP.

## Aula 12.3 — gerar o projeto

1. No VS Code, abra esta pasta do repositório (`ui`) e chame a paleta de comandos (`Ctrl+Shift+P`) →
   **Fiori: Open Application Generator**.
2. Responda ao gerador:

   | Passo | Campo | Resposta |
   |---|---|---|
   | Template | Template | **List Report Page** |
   | Data Source | Data source | **Connect to a System** → **New System** |
   | | URL do sistema | o endereço do seu S/4HANA (por exemplo `https://<servidor>:<porta>`) |
   | | Client | o seu mandante (no curso, `100`) |
   | | Usuário e senha | os seus |
   | | Service | **`ZUI_CHAMADO_O4`** (OData V4) |
   | Entity Selection | Main entity | **`Chamado`** |
   | | Navigation entity | **`_Apontamentos`** |
   | Project Attributes | Module name | **`chamados`** |
   | | Application title | **Gestão de Chamados** |
   | | Application namespace | **`zchm`** |
   | | Project folder path | a pasta `ui` deste repositório |

3. **Finish**. O gerador cria a pasta `ui/chamados` e instala as dependências (`node_modules`, que o
   `.gitignore` do repositório já deixa de fora).

Os nomes dos passos e dos campos mudam um pouco de uma versão do Fiori tools para outra; as respostas são
estas. Em *Minimum SAPUI5 version*, escolha uma versão igual ou anterior à instalada no seu S/4HANA.

### O que conferir no projeto gerado

O arquivo que importa é `webapp/manifest.json`. Namespace e módulo formam o identificador do app, e o
`dataSources` é a única ligação com o backend:

```json
"sap.app": {
  "id": "zchm.chamados",
  "type": "application",
  "title": "{{appTitle}}",
  "dataSources": {
    "mainService": {
      "uri": "/sap/opu/odata4/sap/zui_chamado_o4/srvd/sap/zui_chamado/0001/",
      "type": "OData",
      "settings": { "odataVersion": "4.0" }
    }
  }
}
```

A `uri` do seu projeto é a que o gerador leu do seu sistema; ela pode ser diferente da mostrada aqui.

### Rodar na sua máquina

No terminal, dentro de `ui/chamados`:

```
npm start
```

Um servidor local sobe e o navegador abre o app em `localhost`. A tela é servida da sua máquina; os dados
são os do S/4HANA (no primeiro acesso o navegador pede o usuário e a senha do sistema).

### O serviço não aparece na lista do gerador?

O sistema conecta, a lista de serviços vem, e o `ZUI_CHAMADO_O4` não está nela: em geral o service binding
não foi publicado, ou foi publicado em outro mandante. Abra o service binding no ADT e confira. No
on-premise, o serviço OData V4 também pode ser publicado pela transação de administração do SAP Gateway
(`/IWFND/V4_ADMIN`).

### Exercício da aula

Botão direito na pasta `webapp` → **Show Page Map**: as duas páginas do app (lista e detalhe) desenhadas.
