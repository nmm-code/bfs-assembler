program project1;

uses
  SysUtils,
  dateutils;

{$ASMMODE intel}
const
  Count = 10000000;
type
  TBuffer = packed array[0..Count - 1] of single;
  ta = array[0..7] of single;

  function computeAsm(var t: TBuffer): single;
  var
    get: ta;
    sum: double;
    i: uint64;
  begin
    sum := 0;

    asm
    MOV RBX,t
    end;

    for i := 0 to (Count div 8) - 1 do
    begin
      asm
      VMOVUPS ymm15,[RBX]
      VADDPS  ymm1,ymm1,ymm15
      ADD RBX,8
      end;
    end;

    asm
    VMOVUPS get,ymm1
    end;

    if Count div 8 <> 0 then
      for i := 1 to (Count mod 8) do
      begin
        get[0] := get[0] + t[i + (Count div 8) * 8];
      end;

    for i:= 0 to 7 do
	sum := sum + get[i];

    computeAsm := Sum / Count;
  end;

var
  s: single;
  t: TBuffer;
  I: uint64;
  z1, z2: TDateTime;
begin
  randomize;
  for i := 0 to Count - 1 do
    t[i] := random;

  z1 := now;
  s := computeASM(t);
  z2 := now;

  writeln('Ergebnis: ', s: 0: 10);
  writeln('AVX Zeit(ms):', millisecondsbetween(z1, z2));
end.
