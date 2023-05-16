program parol;
var
  s : string;
begin
  s := '';
  repeat
    writeln('Введите пароль :');
    readln(s);
  until s = 'сережа';
end.