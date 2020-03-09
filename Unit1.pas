unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, Vcl.Grids, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, idglobal, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack;

const

   CONST_START_BYTE = 02; // Byte inicial.
   CONST_END_BYTE = 03; // Byte final.

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    edtIP: TLabeledEdit;
    edtPorta: TLabeledEdit;
    edtComando: TLabeledEdit;
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    Memo1: TMemo;
    IdTCPClient1: TIdTCPClient;
    btnConectar: TButton;
    btnEnviar: TButton;
    Timer1: TTimer;
    btnDesconectar: TButton;
    procedure btnDesconectarClick(Sender: TObject);
    procedure btnConectarClick(Sender: TObject);
    procedure btnEnviarClick(Sender: TObject);
    procedure IdTCPClient1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function stringToBytes(pPackage : String) : TIdBytes;
{ Recebe o pacote de dados no formato texto e converte para um array de bytes,
  adicionando o byte inicial e final, calculando o checksum e convertendo cada
  caracter da string em inteiro. Retorna o array de bytes convertido. }

  procedure NextByte(var pByteArray : TIdBytes; var index : Integer);
  { Disponibiliza mais um byte em um array de bytes, alocando um novo espaço e
    incrementando o índice. }
  begin
    SetLength(pByteArray, Length(pByteArray) + 1);
    inc(index);
  end;
var
  _rChecksum, i, idx : Integer;
begin
  // Inicializa o índice do array e o checksum.
  idx := 0;
  SetLength(Result, 1);
  _rChecksum := 0;

  // Carrega o byte inicial
  Result[idx] := CONST_START_BYTE;

  // Calcula e carrega o tamanho do pacote
  NextByte(Result, idx);
  Result[idx] := Length(pPackage) and $FF;
  NextByte(Result, idx);
  Result[idx] := (Length(pPackage) shr 8) and $FF;

  // Converte cada caracter da string recebida em inteiro e carrega no array
  NextByte(Result, idx);
  for i := 1 to Length(pPackage) do
  begin
    Result[idx] := Ord(pPackage[i]);
    NextByte(Result, idx);
  end;

  // Realiza o cálculo do checksum com os bytes do pacote e com o seu tamanho,
  // e após calcular ele é carregado no array
  for i := 0 to Length(pPackage) do
    _rChecksum := _rChecksum xor Ord(pPackage[i]);
  _rChecksum := _rChecksum xor (Length(pPackage) and $FF);
  _rChecksum := _rChecksum xor ((Length(pPackage) shr 8) and $FF);
  Result[idx] := _rChecksum;

  // Carrega o byte final
  NextByte(Result, idx);
  Result[idx] := CONST_END_BYTE;
end;


procedure TForm1.btnDesconectarClick(Sender: TObject);
begin
  IdTCPClient1.Disconnect;
end;

procedure TForm1.btnConectarClick(Sender: TObject);
begin
  IdTCPClient1.Host := edtIP.Text;
  IdTCPClient1.Port := StrToInt(edtPorta.Text);
  IdTCPClient1.Connect;
end;


procedure TForm1.btnEnviarClick(Sender: TObject);
var
  data: String;
begin
  if not IdTCPClient1.Connected then
    btnConectarClick(btnConectar);

  Memo1.Lines.Text := 'Iniciando';
  Memo1.Lines.Add('');

  data := edtComando.Text;

  Memo1.Lines.Add('Enviando');
  Memo1.Lines.Add('');


  IdTCPClient1.IOHandler.Write(stringToBytes(data));

  Memo1.Lines.Add('Enviado');
  Memo1.Lines.Add('');


  Timer1.Enabled := True;
end;

procedure TForm1.IdTCPClient1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  Memo1.Lines.Add(AStatusText);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  size, i : Integer;
  retornoBytes: TIdBytes;
  retorno_convertido: String;
begin
  // Aguarda toda informação ser retornada para converter
  // Obs: Nos teste o relógio só retorna o tamanho máximo de 4089 bytes
  // independente de quantas informações forem solicitadas
  if IdTCPClient1.IOHandler.InputBufferIsEmpty then
  begin
    IdTCPClient1.IOHandler.CheckForDataOnSource(100);

    if IdTCPClient1.IOHandler.InputBufferIsEmpty then
      Exit;

  end;

  Memo1.Lines.Add('Recebendo');
  Memo1.Lines.Add('');

  size := IdTCPClient1.IOHandler.InputBuffer.Size;
  SetLength(retornoBytes, size );
  IdTCPClient1.IOHandler.ReadBytes(retornoBytes, size, false);

  // despreza o byte inicial e final
  if Length(retornoBytes) > 0 then
    begin
      for i := 3 to Length(retornoBytes) - 3 do
        retorno_convertido := retorno_convertido + chr(retornoBytes[i]);

       Memo1.Lines.Add(retorno_convertido);

       Memo1.Lines.Add('');
       Memo1.Lines.Add('Finalizado');
    end ;

   Timer1.Enabled := False;
end;

end.



