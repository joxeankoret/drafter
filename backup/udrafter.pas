unit udrafter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  SynEdit, SynCompletion, LCLType, ExtDlgs, IniFiles;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    dlgCalculator: TCalculatorDialog;
    dlgCalendar: TCalendarDialog;
    dlgFont: TFontDialog;
    dlgFind: TFindDialog;
    mainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    menuFont: TMenuItem;
    menuCalendar: TMenuItem;
    menuCalculator: TMenuItem;
    menuTools: TMenuItem;
    menuSelectWord: TMenuItem;
    menuSelectLine: TMenuItem;
    MenuItem4: TMenuItem;
    menuSearch: TMenuItem;
    menuRedo: TMenuItem;
    menuPaste: TMenuItem;
    menuSelectAll: TMenuItem;
    MenuItem12: TMenuItem;
    menuAbout: TMenuItem;
    N3: TMenuItem;
    menuOpen: TMenuItem;
    menuSave: TMenuItem;
    menuExit: TMenuItem;
    MenuItem5: TMenuItem;
    menuUndo: TMenuItem;
    menuCut: TMenuItem;
    menuCopy: TMenuItem;
    N2: TMenuItem;
    N1: TMenuItem;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    txtTweets: TSynEdit;
    procedure dlgFindFind(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure menuAboutClick(Sender: TObject);
    procedure menuCalculatorClick(Sender: TObject);
    procedure menuCalendarClick(Sender: TObject);
    procedure menuCopyClick(Sender: TObject);
    procedure menuCutClick(Sender: TObject);
    procedure menuExitClick(Sender: TObject);
    procedure menuFontClick(Sender: TObject);
    procedure menuOpenClick(Sender: TObject);
    procedure menuPasteClick(Sender: TObject);
    procedure menuRedoClick(Sender: TObject);
    procedure menuSaveClick(Sender: TObject);
    procedure menuSearchClick(Sender: TObject);
    procedure menuSelectAllClick(Sender: TObject);
    procedure menuSelectLineClick(Sender: TObject);
    procedure menuSelectWordClick(Sender: TObject);
    procedure menuUndoClick(Sender: TObject);
    procedure txtTweetsChange(Sender: TObject);
    procedure txtTweetsDblClick(Sender: TObject);
  private

  public

  end;

var
  frmMain: TfrmMain;
  g_modifying : boolean;
  g_saved : boolean;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.txtTweetsChange(Sender: TObject);
var
  i      : integer;
  iPos   : integer;
  iTotal : integer;
  iLength: integer;
  tmp1, tmp2 : string;
begin
  g_saved := false;
  iTotal := 0;

  if g_modifying then
  begin
    exit;
  end;

  g_modifying := true;

  for i := 0 to txtTweets.Lines.Count - 1 do
  begin
    iLength := Length(txtTweets.lines[i]);
    if iLength > 280 then
    begin
      iPos := txtTweets.SelStart;
      tmp1 := txtTweets.lines[i].Substring(0, 280);
      tmp2 := txtTweets.lines[i].Substring(280);
      txtTweets.Lines[i] := tmp1;
      txtTweets.Lines.Insert(i+1, '');
      txtTweets.Lines.Insert(i+2, tmp2);
      txtTweets.SelStart := iPos;
      break;
    end;
    iTotal += iLength;
  end;

  g_modifying := false;
end;

procedure TfrmMain.txtTweetsDblClick(Sender: TObject);
begin
  ShowMessage('Total lines ' + IntToStr(txtTweets.Lines.Count));
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  INI : TIniFile;
begin
  g_modifying := false;
  g_saved := true;

  if FileExists('drafter.ini') then
  begin
    Ini := TIniFile.Create('drafter.ini');
    frmMain.Top    := Ini.ReadInteger('Window', 'Top',  0);
    frmMain.Left   := Ini.ReadInteger('Window', 'Left', 0);
    frmMain.Height := Ini.ReadInteger('Window', 'Height', 600);
    frmMain.Width  := Ini.ReadInteger('Window', 'Width', 800);

    txtTweets.Font.Name := Ini.ReadString ('Font', 'Name', 'Courier New');
    txtTweets.Font.Size := Ini.ReadInteger('Font', 'Size', 10);
    Ini.Free;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  Ini : TIniFile;
begin
  Ini := TIniFile.Create('drafter.ini');
  Ini.WriteInteger('Window', 'Top',    frmMain.Top);
  Ini.WriteInteger('Window', 'Left',   frmMain.Left);
  Ini.WriteInteger('Window', 'Height', frmMain.Height);
  Ini.WriteInteger('Window', 'Width',  frmMain.Width);

  Ini.WriteString ('Font', 'Name', txtTweets.Font.Name);
  Ini.WriteInteger('Font', 'Size', txtTweets.Font.Size);
  Ini.Free;
end;

procedure TfrmMain.dlgFindFind(Sender: TObject);
var
  k : integer;
begin
  with Sender as TFindDialog do begin
    k := Pos(FindText, txtTweets.Lines.Text);
    if k > 0 then
    begin
      txtTweets.SelStart := k;
      txtTweets.SelectWord;
      txtTweets.SetFocus;
    end else
      Beep;
  end;
end;

procedure TfrmMain.menuAboutClick(Sender: TObject);
begin
  ShowMessage('Drafter v1.0' + #13#10#13#10 + 'Herramienta simple para creación de hilos en Twitter.' + #13#10 + 'License: Public Domain');
end;

procedure TfrmMain.menuCalculatorClick(Sender: TObject);
begin
  dlgCalculator.Execute;
end;

procedure TfrmMain.menuCalendarClick(Sender: TObject);
begin
  dlgCalendar.Execute;
end;

procedure TfrmMain.menuCopyClick(Sender: TObject);
begin
  txtTweets.CopyToClipboard;
end;

procedure TfrmMain.menuCutClick(Sender: TObject);
begin
  txtTweets.CutToClipboard;
end;

procedure TfrmMain.menuExitClick(Sender: TObject);
var
  BoxStyle : integer;
  Reply    : integer;
begin
  if not g_saved then
  begin
    BoxStyle := MB_ICONQUESTION + MB_YESNO;
    Reply := Application.MessageBox('El archivo no ha sido guardado. ¿Quieres salir de todos modos?', 'MessageBoxDemo', BoxStyle);
    if Reply <> IDYES then
    begin
      exit;
    end;
  end;

  Application.Terminate;
end;

procedure TfrmMain.menuFontClick(Sender: TObject);
begin
  if dlgFont.Execute then
  begin
    txtTweets.Font := dlgFont.Font;
  end;
end;

procedure TfrmMain.menuOpenClick(Sender: TObject);
var
  Reply    : integer;
  BoxStyle : integer;
begin
  if not g_saved then
  begin
    BoxStyle := MB_ICONQUESTION + MB_YESNO;
    Reply := Application.MessageBox('El archivo no ha sido guardado. ¿Quieres abrir otro archivo de todos modos?', 'MessageBoxDemo', BoxStyle);
    if Reply <> IDYES then
    begin
      exit;
    end;
  end;

  if dlgOpen.Execute then
  begin
    txtTweets.Lines.LoadFromFile( dlgOpen.FileName );
    g_saved := true;
  end;
end;

procedure TfrmMain.menuPasteClick(Sender: TObject);
begin
  txtTweets.PasteFromClipboard;
end;

procedure TfrmMain.menuRedoClick(Sender: TObject);
begin
  txtTweets.Redo;
end;

procedure TfrmMain.menuSaveClick(Sender: TObject);
begin
  if dlgSave.Execute then
  begin
    txtTweets.lines.SaveToFile( dlgSave.FileName );
    g_saved := true;
  end;
end;

procedure TfrmMain.menuSearchClick(Sender: TObject);
begin
  dlgFind.Execute;
end;

procedure TfrmMain.menuSelectAllClick(Sender: TObject);
begin
  txtTweets.SelectAll;
end;

procedure TfrmMain.menuSelectLineClick(Sender: TObject);
begin
  txtTweets.SelectLine();
end;

procedure TfrmMain.menuSelectWordClick(Sender: TObject);
begin
  txtTweets.SelectWord;
end;

procedure TfrmMain.menuUndoClick(Sender: TObject);
begin
  txtTweets.Undo;
end;

end.

