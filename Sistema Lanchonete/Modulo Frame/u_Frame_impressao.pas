unit u_Frame_impressao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, Buttons, ToolWin, ExtCtrls;

type
  TFrame_Impressao = class(TFrame)
    Panel1: TPanel;
    BntGrava: TSpeedButton;
    BntFechar: TSpeedButton;
    BntLimpa: TSpeedButton;
    ToolBar1: TToolBar;
    Panel2: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
