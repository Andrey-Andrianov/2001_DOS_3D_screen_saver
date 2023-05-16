var
  s : string;
  num_key,num_char : byte;

const
  s1 : string = 'Sergey';

Procedure WaitKey;
begin
  asm
    mov ax,0
    int 16h
    mov Num_Key,ah
    mov Num_Char,al
  end;
end;

begin
  writeln;
  write('Enter password :   ');
  s := '';
  repeat
    waitkey;
    if (char(num_char) <> char(#13)) and (char(num_char) <> char(#28))
                            and (char(num_char) <> char(#8)) then begin
      write(char(num_char));
      s := s + char(num_char);
    end;
    if (s <> s1) and (char(num_char) = char(#13)) then begin
      s := '';
      writeln;
      write('Enter password :   ');
    end;
    if (char(num_char) = char(#8)) and (length(s) > 0) then begin
      write(char(num_char));
      write(' ');
      write(char(num_char));
      dec(s[0]);
    end;
  until (s = s1) and (char(num_char) = char(#13));
end.
