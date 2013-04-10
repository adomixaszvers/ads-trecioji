program ads3;



uses
  unitas,
  vektorius, DuomenuTipas, duom_type;

procedure SurusiuotiVek(v: vect);
var
  i, j: Longint;
  min: Longint;
  tmp: duomenu_tipas;
begin
  for i := 1 to v.VDydis-1 do
  begin
      min := i;
      for j := i+1 to v.VDydis do
      begin
          if VElem(v, j) < VElem(v, min) then
             min := j;
      end;
      tmp := VElem(v, i);
      VKeisk(v, i, VElem(v, min));
      VKeisk(v, min, tmp);
  end;
end;

begin
end.

