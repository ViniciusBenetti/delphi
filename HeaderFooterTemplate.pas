unit HeaderFooterTemplate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox,Unit1,FMX.Platform,System.IOUtils,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
  Androidapi.JNI.App,
  FMX.Helpers.Android,
  FMX.Platform.Android,
  Androidapi.JNIBridge,
  System.Permissions;



      //unit2
type
  TTaskItem = class
  public
    NomeTarefa: string;
    HorarioTarefa: TTime;


  end;
type
    Tgerenciador = class(TForm)
    Header: TToolBar;
    Footer: TToolBar;
    listadom: TListBox;
    listaseg: TListBox;
    listater: TListBox;
    listaquar: TListBox;
    listaqui: TListBox;
    listasex: TListBox;
    listasab: TListBox;
    editar: TButton;
    StyleBook1: TStyleBook;
    ToolBar1: TToolBar;
    semana: TLabel;
    proximo: TButton;
    anterior: TButton;
    apagar: TButton;
    criar: TButton;
    procedure mostrardiasemana(Sender: TObject);
    procedure proximoClick(Sender: TObject);
    procedure anteriorClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure criarClick(Sender: TObject);
    procedure apagartar(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SolicitarPermissaoAcessoArmazenamento;
    //procedure editarClick(Sender: TObject);
  private
    { Private declarations }
    DataAtual: TDateTime;
  public
    { Public declarations }
    procedure OrdenarListBox(Lista: TListBox);


  end;

var
  gerenciador: Tgerenciador;

implementation

{$R *.fmx}

procedure Tgerenciador.SolicitarPermissaoAcessoArmazenamento;
var
  Permission: JString;
  PermissionStatus: Integer;
  PackageManager: JPackageManager;
  PermissionsArray: TJavaObjectArray<JString>;
begin
  Permission := StringToJString('android.permission.WRITE_EXTERNAL_STORAGE');
  PackageManager := TAndroidHelper.Context.getPackageManager;
  PermissionStatus := PackageManager.checkPermission(Permission, TAndroidHelper.Context.getPackageName);

  if PermissionStatus = TJPackageManager.JavaClass.PERMISSION_GRANTED then
  begin

  end
  else
  begin

    PermissionsArray := TJavaObjectArray<JString>.Create(1);
    PermissionsArray.Items[0] := Permission;
    TAndroidHelper.Activity.requestPermissions(PermissionsArray, 0);
  end;
end;




procedure Tgerenciador.OrdenarListBox(Lista: TListBox);
var
  ListBoxItems: TStringList;
  I, J: Integer;
  TempTime1, TempTime2: TTime;
  Hours1, Minutes1, Hours2, Minutes2: Word;
  Seconds1, Seconds2: Integer;
begin
  ListBoxItems := TStringList.Create();
  try
    // Copia os itens da ListBox para a TStringList
    for I := 0 to Lista.Count - 1 do
      ListBoxItems.Add(Lista.Items[I]);

    // Ordena a TStringList usando Bubble Sort
    for I := 0 to ListBoxItems.Count - 1 do
    begin
      for J := I + 1 to ListBoxItems.Count - 1 do
      begin
        // Extrai horas e minutos manualmente
        Hours1 := StrToInt(Copy(ListBoxItems[I], Pos('-', ListBoxItems[I]) + 2, 2));
        Minutes1 := StrToInt(Copy(ListBoxItems[I], Pos('-', ListBoxItems[I]) + 5, 2));

        Hours2 := StrToInt(Copy(ListBoxItems[J], Pos('-', ListBoxItems[J]) + 2, 2));
        Minutes2 := StrToInt(Copy(ListBoxItems[J], Pos('-', ListBoxItems[J]) + 5, 2));

        // Converte para segundos
        Seconds1 := (Hours1 * 3600) + (Minutes1 * 60);
        Seconds2 := (Hours2 * 3600) + (Minutes2 * 60);

        if Seconds2 < Seconds1 then
        begin
          ListBoxItems.Exchange(I, J);
        end;
      end;
    end;

    // Limpa a ListBox
    Lista.Clear();

    // Copia os itens ordenados de volta para a ListBox
    for I := 0 to ListBoxItems.Count - 1 do
      Lista.Items.Add(ListBoxItems[I]);
  finally
    ListBoxItems.Free();
  end;
end;




procedure Tgerenciador.proximoClick(Sender: TObject);


begin
  // Avançar um dia
  DataAtual := DataAtual + 1;

  // Verificar se o dia é Sábado (7) e ocultar o botão "Próximo"
  if DayOfWeek(DataAtual) = 7 then
    proximo.Visible := False
  else
    proximo.Visible := True;

  // Verificar se o dia é Domingo (1) e ocultar o botão "Anterior"
  if DayOfWeek(DataAtual) = 1 then
    anterior.Visible := False
  else
    anterior.Visible := True;

  // Mostrar o dia da semana atual
  mostrardiasemana(nil);
end;

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


procedure CarregarItens(Lista: TListBox; const CaminhoArquivo: string);
var
  Arquivo: TStringList;
  i: Integer;
begin
  Lista.Items.Clear;
  if FileExists(CaminhoArquivo) then
  begin
    Arquivo := TStringList.Create;
    try
      Arquivo.LoadFromFile(CaminhoArquivo);
      for i := 0 to Arquivo.Count - 1 do
        Lista.Items.Add(Arquivo[i]);
    finally
      Arquivo.Free;
    end;
  end;
end;


procedure Tgerenciador.anteriorClick(Sender: TObject);
begin
  // Retroceder um dia
  DataAtual := DataAtual - 1;

  // Verificar se o dia é Sábado (7) e ocultar o botão "Próximo"
  if DayOfWeek(DataAtual) = 7 then
    proximo.Visible := False
  else
    proximo.Visible := True;

  // Verificar se o dia é Domingo (1) e ocultar o botão "Anterior"
  if DayOfWeek(DataAtual) = 1 then
    anterior.Visible := False
  else
    anterior.Visible := True;

  // Mostrar o dia da semana atual
  mostrardiasemana(nil);
end;

procedure Tgerenciador.apagartar(Sender: TObject);
begin
    if listaseg.ItemIndex >=0 then
    listaseg.Items.Delete(listaseg.ItemIndex);
    if listater.ItemIndex >=0 then
    listater.Items.Delete(listater.ItemIndex);
    if listaquar.ItemIndex >=0 then
    listaquar.Items.Delete(listaquar.ItemIndex);
    if listaqui.ItemIndex >=0 then
    listaqui.Items.Delete(listaqui.ItemIndex);
    if listasex.ItemIndex >=0 then
    listasex.Items.Delete(listasex.ItemIndex);
    if listasab.ItemIndex >=0 then
    listasab.Items.Delete(listasab.ItemIndex);
    if listadom.ItemIndex >=0 then
    listadom.Items.Delete(listadom.ItemIndex);

end;

procedure Tgerenciador.criarClick(Sender: TObject);
begin
      gerenciador.Hide();
      telacriar.Show();

end;

//procedure Tgerenciador.editarClick(Sender: TObject);
//begin
      //gerenciador.Hide();
      //telaeditar.Show();
//end;



procedure Tgerenciador.FormClose(Sender: TObject; var Action: TCloseAction);
var
  CaminhoArquivo: string;
begin
  CaminhoArquivo := ObterCaminhoArquivo;

  SalvarItens(listaseg, CaminhoArquivo + '_segunda.txt');
  SalvarItens(listater, CaminhoArquivo + '_terca.txt');
  SalvarItens(listaquar, CaminhoArquivo + '_quarta.txt');
  SalvarItens(listaqui, CaminhoArquivo + '_quinta.txt');
  SalvarItens(listasex, CaminhoArquivo + '_sexta.txt');
  SalvarItens(listasab, CaminhoArquivo + '_sabado.txt');
  SalvarItens(listadom, CaminhoArquivo + '_domingo.txt');
end;


procedure Tgerenciador.FormCreate(Sender: TObject);
var

  CaminhoArquivo: string;

begin
  SolicitarPermissaoAcessoArmazenamento;
  DataAtual := Now;
  mostrardiasemana(nil);



  CaminhoArquivo := ObterCaminhoArquivo;

  CarregarItens(listaseg, CaminhoArquivo + '_segunda.txt');
  CarregarItens(listater, CaminhoArquivo + '_terca.txt');
  CarregarItens(listaquar, CaminhoArquivo + '_quarta.txt');
  CarregarItens(listaqui, CaminhoArquivo + '_quinta.txt');
  CarregarItens(listasex, CaminhoArquivo + '_sexta.txt');
  CarregarItens(listasab, CaminhoArquivo + '_sabado.txt');
  CarregarItens(listadom, CaminhoArquivo + '_domingo.txt');
end;


procedure Tgerenciador.mostrardiasemana(Sender: TObject);
var
  DiaSemana: string;
begin
    DiaSemana := FormatDateTime('dddd', DataAtual);
    semana.Text := DiaSemana;

    listadom.Visible := False;
    listaseg.Visible := False;
    listater.Visible := False;
    listaquar.Visible := False;
    listaqui.Visible := False;
    listasex.Visible := False;
    listasab.Visible := False;

  // Exibir a ListBox correspondente ao dia da semana
  case DayOfWeek(DataAtual) of
    1: listadom.Visible := True;  // Domingo
    2: listaseg.Visible := True;  // Segunda-feira
    3: listater.Visible := True;  // Terça-feira
    4: listaquar.Visible := True;  // Quarta-feira
    5: listaqui.Visible := True;  // Quinta-feira
    6: listasex.Visible := True;  // Sexta-feira
    7: listasab.Visible := True;  // Sábado

    end;


end;


end.
