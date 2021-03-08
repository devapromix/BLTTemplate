unit Scenes;

interface

type
  TSceneEnum = (scGame);

type
  TScene = class(TObject)
  private

  public
    procedure Render; virtual; abstract;
    procedure Update(var Key: Word); virtual; abstract;
    procedure DrawText(const X, Y: Integer; Text: string); overload;
    function Width: Integer;
    function Height: Integer;
  end;

type
  TScenes = class(TScene)
  private
    FScene: array [TSceneEnum] of TScene;
    FSceneEnum: TSceneEnum;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Render; override;
    procedure Update(var Key: Word); override;
    property Scene: TSceneEnum read FSceneEnum write FSceneEnum;
    function GetScene(I: TSceneEnum): TScene;
    procedure SetScene(SceneEnum: TSceneEnum);
  end;

type
  TScreen = class(TScenes)
  private

  public
    constructor Create();
  end;

type
  TSceneGame = class(TScene)
  private

  public
    procedure Render; override;
    procedure Update(var Key: Word); override;
  end;

var
  Screen: TScreen;

implementation

uses BearLibTerminal, SysUtils, Graphics;

{ TScene }

procedure TScene.DrawText(const X, Y: Integer; Text: string);
begin
  terminal_print(X, Y, Text);
end;

function TScene.Width: Integer;
begin
  Result := terminal_state(TK_WIDTH);
end;

function TScene.Height: Integer;
begin
  Result := terminal_state(TK_HEIGHT);
end;

{ TScenes }

constructor TScenes.Create;
begin
  inherited;
  FScene[scGame] := TSceneGame.Create;
end;        

procedure TScenes.Update(var Key: Word);
begin
  if (FScene[Scene] <> nil) then
    FScene[Scene].Update(Key);
end;

procedure TScenes.Render;
begin
  terminal_clear();
  terminal_bkcolor(0);
  if (FScene[Scene] <> nil) then
    FScene[Scene].Render;
  terminal_bkcolor(0);
end;

destructor TScenes.Destroy;
var
  I: TSceneEnum;
begin
  for I := Low(TSceneEnum) to High(TSceneEnum) do
    FScene[I].Free;
  inherited;
end;

procedure TScenes.SetScene(SceneEnum: TSceneEnum);
begin
  Self.Scene := SceneEnum;
  Self.Render;
end;

function TScenes.GetScene(I: TSceneEnum): TScene;
begin
  Result := FScene[I];
end;

{ TScreen }

constructor TScreen.Create();
begin
  inherited;
  Self.SetScene(scGame);
end;

{ TSceneGame }

procedure TSceneGame.Render;
var
  X, Y: Integer; 
begin
  for Y := 0 to Self.Height - 1 do
    for X := 0 to Self.Width - 1 do
      DrawText(X, Y, '#');
end;

procedure TSceneGame.Update(var Key: Word);
begin

end;

end.
