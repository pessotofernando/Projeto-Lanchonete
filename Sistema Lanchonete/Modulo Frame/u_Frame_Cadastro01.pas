unit u_Frame_Cadastro01;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ToolWin, ComCtrls, StdCtrls, Buttons, ExtCtrls;

type
  TFrame_Cadastro01 = class(TFrame)
    Panel1: TPanel;
    BntAltera: TSpeedButton;
    BntNovo: TSpeedButton;
    BntGrava: TSpeedButton;
    BntExcluir: TSpeedButton;
    BntAnterior: TSpeedButton;
    Codigo: TEdit;
    BntProximo: TSpeedButton;
    BntLimpa: TSpeedButton;
    BntFechar: TSpeedButton;
    SpeedButton9: TSpeedButton;
    Panel2: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
