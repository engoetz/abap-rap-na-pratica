# ABAP RAP na Prática — repositório do curso

Código do app **Gestão de Chamados**, construído aula a aula no curso *ABAP RAP na Prática*.
O repositório está no formato [abapGit](https://abapgit.org) e é instalado no pacote `ZCHM`.

## Como o repositório está organizado

| Referência | O que traz |
|---|---|
| branch `main` | ponto de partida: só a configuração do abapGit e o pacote `ZCHM` |
| branch `m01` … `m12` | o código como fica **no fim de cada módulo** |
| tag `m04-a01`, `m04-a02` … | o código como fica **no fim de cada aula** |
| branch `desafio-contratos` | o enunciado do projeto final (aula 12.6), em `docs/desafio-contratos.md` |

Travou ou pulou um módulo? Puxe a branch do módulo anterior e você está no ponto certo
para começar o seguinte. Quer comparar o seu código com o de uma aula específica? Use a tag da aula.

Aulas só de conceito não mudam o código; a tag delas aponta para o mesmo estado da aula anterior.

Além de `src/` (os objetos ABAP, no formato abapGit), o repositório tem a pasta `docs/`, com material de
apoio, e, a partir do módulo 12, a pasta `ui/chamados`, com o passo a passo do app Fiori gerado pelo
SAP Fiori tools. O abapGit só lê `src/`; as outras pastas não são importadas para o sistema.

## Instalação (S/4HANA on-premise)

1. Crie o pacote `ZCHM` (aula 00.5).
2. Instale o abapGit standalone (programa `ZABAPGIT_STANDALONE`) e execute-o (aula 00.6).
3. **New Online** → endereço deste repositório, pacote `ZCHM`, branch `main` → **Create Online Repo**.
4. Para alcançar a turma: **Branch → Switch** → escolha a branch do módulo → **Pull**.

Sem saída do servidor SAP para a internet? Baixe a branch como ZIP (Code → Download ZIP) e use **New Offline** → **Import zip**.

> **Atenção:** o Pull sobrescreve os objetos do pacote com a versão do repositório.
> Se quiser guardar a sua versão de um objeto, duplique-o antes.

No SAP BTP ABAP Environment o caminho é o mesmo, pelo plug-in abapGit do ADT (view *abapGit Repositories*).

## Requisitos

- S/4HANA on-premise com RAP (o tipo *Behavior Definition* aparece no ADT) e ADT no Eclipse.
- Alguns recursos dependem de release recente (`strict ( 2 )`, side effects na BDEF, business events).
  A aula em que cada um aparece avisa.
- Idioma original dos objetos: português (`PT`).

## Objetos principais

```
ZR_Chamado (raiz)            tabela zchm_chamado
 └─ ZR_Apontamento (filho)   tabela zchm_apont
ZI_ClienteVH, ZI_PrioridadeVH, ZI_StatusVH   ajudas de pesquisa
ZC_Chamado, ZC_Apontamento                   projeção + metadata extension
ZUI_CHAMADO / ZUI_CHAMADO_O4                 service definition / binding OData V4 - UI
ZBP_R_CHAMADO                                behavior pool

Módulo 10   ZR_ChamadoU, ZBP_R_CHAMADOU, ZCL_CHM_BUFFER     BO unmanaged de exemplo
Módulo 11   ZCL_CHM_VE_DIAS                                 virtual element
            ZCE_SlaChamado, ZCL_CHM_SLA_QUERY               custom entity
            ZCL_CHM_EVT_CHAMADO                             handler do business event
            ZX_CHAMADO, ZBP_X_CHAMADO                       BDEF extension
            ZI_ChamadoTP                                    interface do BO
            ZAPI_CHAMADO / ZAPI_CHAMADO_O4                  service definition / binding OData V4 - Web API
Módulo 12   ZCL_CHM_TESTE_CHAMADO                           testes ABAP Unit
            ui/chamados                                     passo a passo do app Fiori
```

A lista completa, com a aula em que cada objeto nasce, está em [docs/objetos.md](docs/objetos.md).
O checklist de revisão da aula 12.5 está em [docs/checklist-bo.md](docs/checklist-bo.md).

## Uso

Material de apoio do curso, para estudo dos alunos. O código é original do curso e não deve ser
usado em produção sem revisão: ele foi escrito para ensinar um conceito por aula.
