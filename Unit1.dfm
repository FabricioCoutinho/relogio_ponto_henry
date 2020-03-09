object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Exemplo de Coleta de Dados do Rel'#243'gio de Ponto HENRY'
  ClientHeight = 365
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 365
    Align = alLeft
    TabOrder = 0
    object edtIP: TLabeledEdit
      Left = 24
      Top = 32
      Width = 121
      Height = 21
      EditLabel.Width = 10
      EditLabel.Height = 13
      EditLabel.Caption = 'IP'
      TabOrder = 0
    end
    object edtPorta: TLabeledEdit
      Left = 24
      Top = 88
      Width = 121
      Height = 21
      EditLabel.Width = 20
      EditLabel.Height = 13
      EditLabel.Caption = 'Port'
      TabOrder = 1
      Text = '3000'
    end
    object edtComando: TLabeledEdit
      Left = 24
      Top = 144
      Width = 121
      Height = 21
      EditLabel.Width = 45
      EditLabel.Height = 13
      EditLabel.Caption = 'Comando'
      TabOrder = 2
      Text = '01+RE+00'
    end
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 347
      Width = 183
      Height = 17
      Align = alBottom
      TabOrder = 3
    end
    object btnConectar: TButton
      Left = 24
      Top = 183
      Width = 75
      Height = 25
      Caption = 'Conectar'
      TabOrder = 4
      OnClick = btnConectarClick
    end
    object btnEnviar: TButton
      Left = 24
      Top = 261
      Width = 75
      Height = 25
      Caption = 'Enviar'
      TabOrder = 5
      OnClick = btnEnviarClick
    end
    object btnDesconectar: TButton
      Left = 24
      Top = 223
      Width = 75
      Height = 25
      Caption = 'Disconectar'
      TabOrder = 6
      OnClick = btnDesconectarClick
    end
  end
  object Panel1: TPanel
    Left = 185
    Top = 0
    Width = 450
    Height = 365
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 1
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 448
      Height = 363
      Align = alClient
      TabOrder = 0
    end
  end
  object IdTCPClient1: TIdTCPClient
    OnStatus = IdTCPClient1Status
    ConnectTimeout = -1
    IPVersion = Id_IPv4
    Port = 3000
    ReadTimeout = -1
    Left = 249
    Top = 256
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 321
    Top = 256
  end
end
