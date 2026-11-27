@EndUserText.label: 'Resumo dos chamados'
define abstract entity ZA_ResumoChamados
{
  Abertos     : abap.int4;
  Encerrados  : abap.int4;
  HorasTotais : abap.dec( 9, 2 );
}
