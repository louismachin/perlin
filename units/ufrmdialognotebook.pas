unit uFrmDialogNotebook;

{$mode objfpc}{$H+}


{
Change such that the user selects a style, such as Basic,
and then gets the option of selecting headers, textboxes etc.

Perhaps encapsulate them so multiple styles can be used in one
page. Or have an option of default style vs. selecting each style.

Possible, use a menu to organise the objects like
CGP
> Header
> Text
Basic
> Header
> Text
> Image
}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls;

type

  { TfrmDialogNotebook }

  TfrmDialogNotebook = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure okClick(Sender: TObject);
    procedure cancelClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmDialogNotebook: TfrmDialogNotebook;
  nameLbl, tagLbl: TLabel;
  nameEdit: TEdit;
  tagSelect: TComboBox;
  okImg, cancelImg: TImage;

implementation

uses
  uGUI, uFrmDash;

{$R *.lfm}

{ TfrmDialogNotebook }

procedure TfrmDialogNotebook.okClick(Sender: TObject);
var
  TagClr, SelectedTagClr: TTagColor;
  NameStr: string;
  i: integer;
  txt: textfile;
begin
  // Get Parameters
  SelectedTagClr:= tcRed;
  for TagClr:= tcRed to tcPink do
    if TagColorStr[TagClr] = tagSelect.Text then
      SelectedTagClr:= TagClr;
  NameStr:= nameEdit.Text;
  // Create
  sidebar.Buttons.AddNotebook(notebookPanel, NameStr, SelectedTagClr);
  AssignFile(txt,'notes/notebooks.perlin');
  //Rewrite(txt);
  Append(txt);
  writeln(txt,NameStr);
  writeln(txt,SelectedTagClr);
  CloseFile(txt);
  AssignFile(txt,concat('notes/',lowercase(NameStr),'.perlin'));
  rewrite(txt);
  CloseFile(txt);
  frmDialogNotebook.Hide;
end;

procedure TfrmDialogNotebook.cancelClick(Sender: TObject);
begin
  frmDialogNotebook.Hide;
end;

procedure TfrmDialogNotebook.FormCreate(Sender: TObject);
var
  TagClr: TTagColor;
begin
  with frmDialogNotebook do
    begin
      Caption:= 'Create Notebook';
      Width:= 604;
      Height:= 113;
      Left:= frmDash.Left + ((frmDash.Width-Width) div 2);
      Top:= frmDash.Top + ((frmDash.Height-Height) div 2);
      Color:= clBorderGrey; //trial
      Visible:= False;
    end;
  nameLbl:= TLabel.Create(nil);
  with nameLbl do
    begin
      Parent:= frmDialogNotebook;
      Left:= 16;
      Top:= 18;
      Caption:= 'Name:'
    end;
  nameEdit:= TEdit.Create(nil);
  with nameEdit do
    begin
      Parent:= frmDialogNotebook;
      Top:= 16;
      Left:= 104;
      Width:= frmDialogNotebook.Width-118;
    end;
  tagLbl:= TLabel.Create(nil);
  with tagLbl do
    begin
      Parent:= frmDialogNotebook;
      Left:= 16;
      Top:= 46;
      Caption:= 'Tag-Color:'
    end;
  tagSelect:= TComboBox.Create(nil);
  with tagSelect do
    begin
      Parent:= frmDialogNotebook;
      Left:= 104;
      Top:= 43;
      Width:= frmDialogNotebook.Width-118;
      for TagClr:= tcRed to tcPink do
        AddItem(TagColorStr[TagClr],nil);
    end;
  okImg:= TImage.Create(nil);
  with okImg do
    begin
      Parent:= frmDialogNotebook;
      Width:= 59;
      Height:= 25;
      Left:= frmDialogNotebook.Width-(2*Width+27);
      Top:= frmDialogNotebook.Height-(Height+11);
      Picture.LoadFromFile('data/okImg.png');
      Cursor:= crHandpoint;
      OnClick:= @okClick;
    end;
  cancelImg:= TImage.Create(nil);
  with cancelImg do
    begin
      Parent:= frmDialogNotebook;
      Width:= 59;
      Height:= 25;
      Left:= frmDialogNotebook.Width-(Width+15);
      Top:= frmDialogNotebook.Height-(Height+11);
      Picture.LoadFromFile('data/cancelImg.png');
      Cursor:= crHandpoint;
      OnClick:= @cancelClick;
    end;
end;

procedure TfrmDialogNotebook.FormResize(Sender: TObject);
begin
  nameEdit.Width:= frmDialogNotebook.Width-118;
  tagSelect.Width:= frmDialogNotebook.Width-118;
  with okImg do
    begin
      Left:= frmDialogNotebook.Width-(2*Width+27);
      Top:= frmDialogNotebook.Height-(Height+11);
    end;
  with cancelImg do
    begin
      Left:= frmDialogNotebook.Width-(Width+15);
      Top:= frmDialogNotebook.Height-(Height+11);
    end;
end;

end.

