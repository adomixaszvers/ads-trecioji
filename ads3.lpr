program ads3;



uses
  unitas,
  vektorius,
  DuomenuTipas,
  duom_type;

const
  DarboLaikas = 1440;

type
  dtP = ^duomenu_tipas;

  procedure SurusiuotiVek(v: vect);
  var
    i, j: longint;
    min: longint;
    tmp: duomenu_tipas;
  begin
    for i := 1 to v.VDydis - 1 do
    begin
      min := i;
      for j := i + 1 to v.VDydis do
      begin
        if VElem(v, j) < VElem(v, min) then
          min := j;
      end;
      tmp := VElem(v, i);
      VKeisk(v, i, VElem(v, min));
      VKeisk(v, min, tmp);
    end;
  end;

  function ParamSkaitymas(DFPav: string; var skait_at_tik, ar_yra_knyga: shortint;
  var v: vect): shortint;
  var
    df: Text;
    tmp: duomenu_tipas;
  begin
    Assign(df, DFPav);
  {$I-}
    Reset(df);
    if IOResult <> 0 then
    begin
      Result := 1;
      Exit;
    end;
  {$I+}
    Read(df, skait_at_tik);
    if (skait_at_tik < 0) or (100 < skait_at_tik) then
    begin
      Result := 2;
      Exit;
    end;
    Read(df, ar_yra_knyga);
    if (ar_yra_knyga < 0) or (100 < ar_yra_knyga) then
    begin
      Result := 3;
      Exit;
    end;
    VKurk(v);
    while not EOF(df) do
    begin
      Read(df, tmp);
      VPrid(v, tmp);
    end;
    Result := 0;
  end;

procedure Rask(v: vect; duom: duomenu_tipas; var arRado: boolean; var indeksas: Longint);
var
  i: longint;
begin
  arRado:= False;
  for i:= 1 to v.VDydis do
  begin
    if VElem(v, i) = duom then
    begin
       arRado:= True;
       break;
    end;
  end;
  indeksas:= i;
end;

begin
end.
