program box;
uses pal,crt,grtext,graphs2;
type
  scrtype = array[0..199,0..319]of byte; {тип массива для экрана}
  scrptr = ^scrtype;
  p1 = record
    r : byte;
    g : byte;
    b : byte;
  end;
  a1 = record
    x : single;
    y : single;
    z : single;
    x1 : single;
    y1 : single;
    z1 : single;
  end;
  setaps = record
    col : boolean;
    line199:boolean;
    blur:boolean;
  end;
var
{  np3 : scrptr;
  scr : scrptr;}
  p : array[0..255]of p1;
  a2 : array[1..8,1..2]of integer;
  k,i,j,lxxx,kx : integer;
  a,b,t: single;
  scale1 : single;
  num_key,num_char:byte;
  EXIT : BOOLEAN;
  por_x : byte;
  por_s : string;
  por_s2 : string;
  setap :setaps;
  f : text;
const
{  por_s2 = 'box';}
  r1 : array[1..12,1..2]of integer =
   ((1,2),(2,3),(3,4),(4,1),(5,6),(6,7),(7,8),(8,5),(8,4),(7,3),(6,2),(1,5));
  r2 : array[1..8]of a1 =
   ((x:50;y:-50;z:-50),(x:50;y:-50;z:50),(x:-50;y:-50;z:50),
   (x:-50;y:-50;z:-50),(x:50;y:50;z:-50),(x:50;y:50;z:50),
   (x:-50;y:50;z:50),(x:-50;y:50;z:-50));

Procedure WaitKey; { процедура ждет нажатия на клавишу и заносит в глобальные }
assembler;         { переменные Num_Key - номер нажатой клавиши, }
    asm;           {            Num_Char - номер введенного символа }
    mov ax,0
    int 16h
    mov Num_Key,ah
    mov Num_Char,al
    end;

procedure setpal2;
var
  i : integer;
begin
     for i := 0 to 63 do begin
       p[i].r := i;
       p[i].g := 0;
       p[i].b := 0;
     end;
     for i := 0 to 63 do begin
       p[i+63].r := 63;
       p[i+63].g := i;
       p[i+63].b := 0;
     end;
     for i := 0 to 63 do begin
       p[i+126].r := 63;
       p[i+126].g := 63;
       p[i+126].b := i;
     end;
   setpal(p[0].r,0,256);                {устанавливаем нужную палитру}
end;


procedure SwapInt(var a,b:integer);
var
  c : integer;
begin
  c := a;
  a := b;
  b := c;
end;

function Sgn(x:integer):integer;
begin
  if x >= 0 then
    Sgn := 1
  else
    Sgn := -1;
end;

Procedure RotateCordsR( a, b, t : Single; NumPts : Word; b1 : byte);
Var I : Integer;
    sinalpha,cosalpha,sinbeta,cosbeta,sintheta,costheta : single;
    X,Y,Z,X1,Y1,Z1 : single;
Begin
   sinalpha := sin(a); cosalpha := cos(a);
   sinbeta  := sin(b); cosbeta  := cos(b);
   sintheta := sin(t); costheta := cos(t);
   For I := 1 To NumPts Do begin
     X := r2[r1[i,b1]].X;
     Y := r2[r1[i,b1]].Y;
     Z := r2[r1[i,b1]].Z;
   { вокpуг оси X }
     Y1 := Y*Cosalpha-Z*Sinalpha;
     Z1 := Y*Sinalpha+Z*Cosalpha;
     Y := Y1; Z := Z1;
   { вокpуг оси Y }
     X1 := X*Cosbeta+Z*Sinbeta;
     Z1 := -X*Sinbeta+Z*Cosbeta;
     X := X1; Z := Z1;
   { вокpуг оси Z }
     X1 := X*Costheta-Y*Sintheta;
     Y1 := X*Sintheta+Y*Costheta;
     X := X1; Y := Y1;
     r2[r1[i,b1]].X1 := round(X * scale1);
     r2[r1[i,b1]].Y1 := round(Y * scale1);
     r2[r1[i,b1]].Z1 := round(Z * scale1);
   end;
End;


procedure DrawLine(x1,y1,x2,y2:integer;color,c:byte);
var
  j,steps,sx,sy,dx,dy,e : integer;
  step : boolean;
begin
  dx := abs(x2 - x1);
  sx := sgn(x2 - x1);
  dy := abs(y2 - y1);
  sy := sgn(y2 - y1);
  step := (dy > dx);
  if step then begin
    SwapInt(x1,y1);
    SwapInt(dx,dy);
    SwapInt(sx,sy);
  end;
  e := 2 * dy - dx;
  for j := 1 to dx do begin
    if step then
     if c = 2 then
      np2^[x1,y1] := random(c)*color
     else
      scr^[x1,y1] := color
    else
     if c = 2 then
      np2^[y1,x1] := random(c)*color
     else
      scr^[y1,x1] := color;
    while e >= 0 do begin
      inc(y1,sy);
      dec(e,2 * dx);
    end;
    inc(x1,sx);
    inc(e,2 * dy);
  end;
     if c = 2 then
  np2^[y2,x2] := random(c)*color
     else
      scr^[y2,x2] := color;
end;

begin
   assign(f,'parol.dat');
   reset(f);
   readln(f,por_s2);
   close(f);
   setap.col := false;
   setap.line199 := true;
   setap.blur := true;
   kx := 160;
   por_s := '';
   por_x := 0;
   scr:=ptr(SegA000,0);
   getmem(np2,sizeof(np2^));
   for k := 1 to 12 do begin
     r2[r1[k,2]].x1 := 0;
     r2[r1[k,2]].y1 := 0;
     r2[r1[k,2]].z1 := 0;
     r2[r1[k,1]].x1 := 0;
     r2[r1[k,1]].y1 := 0;
     r2[r1[k,1]].z1 := 0;
   end;
   asm
     mov ax , $13
     int $10
   end;
   scale1 := 1;
   SETGTCOL(187);
   a := 0;
   b := 0;
   t := 0;
   fillchar(np2^,sizeof(np2^),0);
   setpal2;
   EXIT := FALSE;
   repeat
     a := a + 0.05;
     b := b + 0.05;
     t := t + 0.05;
     RotateCordsR( a, b, t ,12,1);
     if not setap.blur then
       fillchar(np2^,sizeof(np2^),0);{}
     puttext(1,1,'Введите пароль :');
     for k := por_x downto 1 do
       putchar(8 + k*8,10,'*');
     for lxxx := 1 to 1 do begin
      if setap.line199 then
       for k := 1 to 318 do
         np2^[199,k] := random(2)*255;{}
       for K := 1 to 12 do
         drawline(round(kx + r2[r1[k,1]].x1),round(100 + r2[r1[k,1]].z1),
         round(kx + r2[r1[k,2]].x1),round(100 + r2[r1[k,2]].z1),191,2);
       for j :=1 to 199 do
         for i :=1 to 318 do
           np2^[j-1,i] := np2^[j,i];
       for j :=1 to 199 do
         for i :=1 to 318 do begin
           np2^[j,i] :=(np2^[j,i]+np2^[j-1,i-1]+np2^[j,i+1]+np2^[j,i-1]) div 4;{}
         end;
     end;
     move(np2^,scr^,sizeof(scr^)-640);
     if setap.col then
      for K := 1 to 12 do
       drawline(round(kx + r2[r1[k,1]].x1),round(100 + r2[r1[k,1]].z1),
       round(kx + r2[r1[k,2]].x1),round(100 + r2[r1[k,2]].z1),189,1); {}
     if keypressed then begin
       waitkey;
{       if (num_key <> 1) and (por_x <= 254) then begin
         inc(por_x);
         por_s := por_s + char(num_char);
       end else begin
         por_x := 0;
         por_s := '';
       end;}
       case num_key of
         78: if scale1 < 1.05 then scale1 := scale1 + 0.05;
         74: if scale1 > 0.05 then scale1 := scale1 - 0.05;
         77: if kx < 210 then inc(kx,5);
         75: if kx > 90 then dec(kx,5);
         82: setap.col := not setap.col;
         71: setap.line199 := not setap.line199;
         73: setap.blur := not setap.blur;
         14: if por_x > 0 then begin dec(por_x); dec(por_s[0]); end;
         28: if (por_s = por_s2) then EXIT := TRUE;
         1 : begin por_x := 0; por_s := ''; end;
         else if por_x < 37 then begin
           por_s := por_s + char(num_char);
           inc(por_x);
         end;
       end;
     end;
   until EXIT;
  freemem(np2,sizeof(np2^));
   asm
     mov ax , $0003
     int $10
   end;
end.