program Template;

uses
  SysUtils,
  BearLibTerminal in 'Sources\Third-Party\BearLibTerminal\BearLibTerminal.pas',
  Scenes in 'Scenes\Scenes.pas';

var
  Key: Word = 0;
  IsRender: Boolean = True;

begin
  terminal_open();
  Screen := TScreen.Create;
  try
    Screen.Render;
    terminal_refresh();
    repeat
      if IsRender then Screen.Render;
      Key := 0;
      if terminal_has_input() then
      begin
        Key := terminal_read();
        Screen.Update(Key);
        IsRender := True;
        Continue;
      end;
      if IsRender then terminal_refresh();
      terminal_delay(25);
      IsRender := False;
    until (Key = TK_CLOSE);
    terminal_close();
  finally
    Screen.Free;
  end;

end.
