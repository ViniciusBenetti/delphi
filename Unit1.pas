unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.DateTimeCtrls, FMX.Edit, FMX.Controls.Presentation,System.Generics.Collections,FMX.ListBox,FMX.Platform,System.IOUtils;

type
  Ttelacriar = class(TForm)
    nome: TLabel;
    horario: TLabel;
    repete: TLabel;
    nomecampo: TEdit;
    horariocampo: TTimeEdit;
    segunda: TCheckBox;
    terça: TCheckBox;
    quarta: TCheckBox;
    quinta: TCheckBox;
    sexta: TCheckBox;
    sabado: TCheckBox;
    domingo: TCheckBox;
    lembrete: TLabel;
    lembretecheck: TCheckBox;
    concluido: TButton;
    voltar: TButton;
    stylebook2: TStyleBook;
    procedure concluidoClick(Sender: TObject);
    procedure voltarinicio(Sender: TObject);
    procedure salvarclose(Sender: TObject; var Action: TCloseAction);
  private
  public

  end;

var
  telacriar: Ttelacriar;

implementation

{$R *.fmx}

uses HeaderFooterTemplate;  //GlobalVars

function ObterCaminhoArquivo: string;
begin
  {$IFDEF MSWINDOWS}
  Result := TPath.Combine(TPath.GetDocumentsPath, 'dados_tarefas.txt');
  {$ENDIF}

  {$IFDEF ANDROID}
  Result := TPath.Combine(TPath.GetDocumentsPath, 'dados_tarefas.txt');
  {$ENDIF}
end;

procedure SalvarItens(Lista: TListBox; const CaminhoArquivo: string);
var
  Arquivo: TStringList;
  i: Integer;
begin
  Arquivo := TStringList.Create;
  try
    for i := 0 to Lista.Count - 1 do
      Arquivo.Add(Lista.Items[i]);
    Arquivo.SaveToFile(CaminhoArquivo);
  finally
    Arquivo.Free;
  end;
end;



procedure Ttelacriar.concluidoClick(Sender: TObject);
var
  horario,dados: string;

  begin
  // Verificar se o nomecampo está vazio
  if nomecampo.Text = '' then
  begin
    ShowMessage('Por favor, digite um nome.');
    Exit; // Sai do procedimento sem continuar
  end;
  if Pos('-', nomecampo.Text) > 0 then
  begin
    ShowMessage('O nome não pode conter o caractere "-".');
    Exit;
  end;



  // Verificar se nenhuma checkbox está marcada
  if not (domingo.IsChecked or segunda.IsChecked or terça.IsChecked or quarta.IsChecked or quinta.IsChecked or sexta.IsChecked or sabado.IsChecked) then
  begin
    ShowMessage('Por favor, marque pelo menos um dia.');
    Exit; // Sai do procedimento sem continuar
  end;
  dados := nomecampo.Text+' - '+formatDateTime('hh:mm', horariocampo.Time);
  horario := formatDateTime('hh:mm', horariocampo.Time);
   {   CheckboxStates := '';
      if domingo.IsChecked then
        CheckboxStates := CheckboxStates + '1'
      else
        CheckboxStates := CheckboxStates + '0';

      if segunda.IsChecked then
        CheckboxStates := CheckboxStates + '1'
      else
        CheckboxStates := CheckboxStates + '0';

      if terça.IsChecked then
        CheckboxStates := CheckboxStates + '1'
      else
        CheckboxStates := CheckboxStates + '0';

      if quarta.IsChecked then
        CheckboxStates := CheckboxStates + '1'
      else
        CheckboxStates := CheckboxStates + '0';

      if quinta.IsChecked then
        CheckboxStates := CheckboxStates + '1'
      else
        CheckboxStates := CheckboxStates + '0';

      if sexta.IsChecked then
        CheckboxStates := CheckboxStates + '1'
      else
        CheckboxStates := CheckboxStates + '0';

      if sabado.IsChecked then
        CheckboxStates := CheckboxStates + '1'
      else
        CheckboxStates := CheckboxStates + '0';
    }


      if domingo.IsChecked then
          gerenciador.listadom.Items.Add(dados);

      if segunda.IsChecked then
          gerenciador.listaseg.Items.Add(dados);

      if terça.IsChecked then
          gerenciador.listater.Items.Add(dados);

      if quarta.IsChecked then
          gerenciador.listaquar.Items.Add(dados);

      if quinta.IsChecked then
          gerenciador.listaqui.Items.Add(dados);

      if sexta.IsChecked then
          gerenciador.listasex.Items.Add(dados);

      if sabado.IsChecked then
          gerenciador.listasab.Items.Add(dados);


    //dadospv := dados + CheckboxStates;
    //listadados.Add(dados);
    //listadadospv.Add(dadospv);

    gerenciador.Show();
    gerenciador.OrdenarListBox(gerenciador.listaseg);
    gerenciador.OrdenarListBox(gerenciador.listater);
    gerenciador.OrdenarListBox(gerenciador.listaquar);
    gerenciador.OrdenarListBox(gerenciador.listaqui);
    gerenciador.OrdenarListBox(gerenciador.listasex);
    gerenciador.OrdenarListBox(gerenciador.listasab);
    gerenciador.OrdenarListBox(gerenciador.listadom);
    segunda.IsChecked := False;
    terça.IsChecked := False;
    quarta.IsChecked := False;
    quinta.IsChecked := False;
    sexta.IsChecked := False;
    sabado.IsChecked := False;
    domingo.IsChecked := False;
    nomecampo.Text := '';
    horariocampo.Text := '12:00';

    Self.Hide();
end;


procedure Ttelacriar.salvarclose(Sender: TObject; var Action: TCloseAction);
var
  CaminhoArquivo: string;
begin
  CaminhoArquivo := ObterCaminhoArquivo;

  SalvarItens(gerenciador.listaseg, CaminhoArquivo + '_segunda.txt');
  SalvarItens(gerenciador.listater, CaminhoArquivo + '_terca.txt');
  SalvarItens(gerenciador.listaquar, CaminhoArquivo + '_quarta.txt');
  SalvarItens(gerenciador.listaqui, CaminhoArquivo + '_quinta.txt');
  SalvarItens(gerenciador.listasex, CaminhoArquivo + '_sexta.txt');
  SalvarItens(gerenciador.listasab, CaminhoArquivo + '_sabado.txt');
  SalvarItens(gerenciador.listadom, CaminhoArquivo + '_domingo.txt');
end;

procedure Ttelacriar.voltarinicio(Sender: TObject);
begin
        gerenciador.Show();
        gerenciador.OrdenarListBox(gerenciador.listaseg);
        gerenciador.OrdenarListBox(gerenciador.listater);
        gerenciador.OrdenarListBox(gerenciador.listaquar);
        gerenciador.OrdenarListBox(gerenciador.listaqui);
        gerenciador.OrdenarListBox(gerenciador.listasex);
        gerenciador.OrdenarListBox(gerenciador.listasab);
        gerenciador.OrdenarListBox(gerenciador.listadom);
        telacriar.Hide();
end;

end.
