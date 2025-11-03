unit u_Frame_Recebimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, Buttons, ToolWin, ExtCtrls;

type
  TFrame_Recebimento = class(TFrame)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    BntGrava: TSpeedButton;
    ToolButton1: TToolButton;
    BntLimpa: TSpeedButton;
    BntFechar: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
