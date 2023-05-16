unit pal;
interface
procedure setpal(var pal:byte;nbegpal,lenpal:integer);
procedure getpal(var pal:byte;nbegpal,lenpal:integer);
implementation
{установка 256 цветной палитры}
procedure setpal(var pal:byte;nbegpal,lenpal:integer);
assembler;
asm
              push ds
              push es
              les dx,pal
              mov ax,1012h
              mov bx,nbegpal
              mov cx,lenpal
              int 10h
              pop es
              pop ds
end;
{чтение 256 цветной палитры}
procedure getpal(var pal:byte;nbegpal,lenpal:integer);
assembler;
asm
              push ds
              push es
              les dx,pal
              mov ax,1017h
              mov bx,nbegpal
              mov cx,lenpal
              int 10h
              pop es
              pop ds
end;
end.