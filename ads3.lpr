program ads3;



uses
  heaptrc,
  vektorius,
  DuomenuTipas,
  duom_type,
  unitas;

const
  DarboLaikas = 20000;

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
      ParamSkaitymas := 1;
      Exit;
    end;
  {$I+}
    Read(df, skait_at_tik);
    if (skait_at_tik < 0) or (100 < skait_at_tik) then
    begin
      ParamSkaitymas := 2;
      Close(df);
      Exit;
    end;
    Read(df, ar_yra_knyga);
    if (ar_yra_knyga < 0) or (100 < ar_yra_knyga) then
    begin
      ParamSkaitymas := 3;
      Close(df);
      Exit;
    end;
    VKurk(v);
    while not EOF(df) do
    begin
      Read(df, tmp);
      VPrid(v, tmp);
    end;
    VNaikElem(v, v.VDydis); //Kazkodėl vis nulį prideda
    ParamSkaitymas := 0;
    Close(df);
  end;

  procedure Rask(v: vect; duom: duomenu_tipas; var arRado: boolean;
  var indeksas: longint);
  var
    i: longint;
  begin
    arRado := False;
    for i := 1 to v.VDydis do
    begin
      if VElem(v, i) = duom then
      begin
        arRado := True;
        break;
      end;
    end;
    indeksas := i;
  end;

  procedure Rask(m: TMedis; key: duomenu_tipas; var indeksas: longint);
  var
    elem: T_Lapas;
  begin
    indeksas := 0;
    elem := m.galva;
    while elem <> nil do
    begin
      Inc(indeksas);
      if elem^.duom = key then
        break;
      if elem^.duom > key then
        elem := elem^.kaire
      else
        elem := elem^.desine;
    end;
  end;

  procedure VKopijuok(saltinis: vect; var tikslas: vect);
  var
    i: longint;
  begin
    //VNaik(tikslas);
    VKurk(tikslas);
    for i := 1 to saltinis.VDydis do
      VPrid(tikslas, VElem(saltinis, i));
  end;

  procedure VMazinkVienetu(var v: vect);
  var
    i, j: longint;
    temp: duomenu_tipas;
  begin
    i := 1;
    j := 0;
    for i := 1 to v.VDydis do
      VKeisk(v, i, VElem(v, i) - 1);
    i := 1;
    while i <= v.VDydis do
      if VElem(v, i) = 0 then
        VNaikElem(v, i)
      else
        Inc(i);
  end;

  procedure MKopijuok(v: vect; var m: TMedis);
  var
    i: longint;
    klaida: boolean;
  begin
    {if RaskAuksti(m) = 0 then
      TrinkM(m);}
    m.sukurtas:=False;
    Kurti(m, klaida);
    for i := 1 to v.VDydis do
    begin
      Iterpimas_Medis(VElem(v, i), m, klaida);
    end;
  end;

  function Ivykis(tikimybe: shortint): boolean;
  begin
    Ivykis := Random(101) >= tikimybe;
  end;

  procedure BeDublikatu(var v: vect);
  var
    m: TMedis;
    klaida: boolean;

    procedure RekursiskaiPridek(elem: T_Lapas);
    begin
      if elem = nil then
        exit;
      VPrid(v, elem^.duom);
      RekursiskaiPridek(elem^.kaire);
      RekursiskaiPridek(elem^.desine);
    end;

  begin
    m.sukurtas:=False;

    Kurti(m, klaida);
    while v.VDydis > 0 do
    begin
      Iterpimas_Medis(VElem(v, v.VDydis), m, klaida);
      VNaikElem(v, v.VDydis);
    end;
    RekursiskaiPridek(m.galva);
    Naikinti_Medi(m);
  end;

  procedure DarboDiena(skait_at_tik, ar_yra_knyga: shortint; v: vect;
  var max_darb_n, max_darb_r, max_darb_m: longint);
  var
    dabartinis_laikas: integer;
    per_kiek: longint;
    per_kiek_small: smallint;
    ieskoma: duomenu_tipas;
    knygos_m: TMedis;
    knygos_n, knygos_r, darb_n, darb_r, darb_m: vect;
    klaida: boolean;
  begin
    max_darb_n := 0;
    max_darb_r := 0;
    max_darb_r := 0;
    VKopijuok(v, knygos_n);
    VKopijuok(v, knygos_r);
    SurusiuotiVek(knygos_r);
    MKopijuok(v, knygos_m);
    //Balansavimas(knygos_m, klaida);
    VKurk(darb_n);
    VKurk(darb_r);
    VKurk(darb_m);
    for dabartinis_laikas := 0 to DarboLaikas - 1 do
    begin
      if Ivykis(skait_at_tik) and (knygos_n.VDydis > 0) then
      begin
        if Ivykis(ar_yra_knyga) then
        begin
          per_kiek := Random(knygos_n.VDydis) + 1;
          VPrid(darb_n, per_kiek);
          ieskoma := VElem(knygos_n, per_kiek);
          //VNaikElem(knygos_n, per_kiek);

          Rask(knygos_r, ieskoma, klaida, per_kiek);
          //VNaikElem(knygos_r, per_kiek);
          VPrid(darb_r, per_kiek);

          Rask(knygos_m, ieskoma, per_kiek);
          //DeleteElement(knygos_m, ieskoma);
          VPrid(darb_m, per_kiek);

          if max_darb_n < darb_n.VDydis then
            max_darb_n := darb_n.VDydis;

          if max_darb_r < darb_r.VDydis then
            max_darb_r := darb_r.VDydis;

          if max_darb_m < darb_m.VDydis then
            max_darb_m := darb_m.VDydis;
        end;
      end;
      //WriteLn('Ciklas ', dabartinis_laikas);
      //VRasyk(darb_n);
      //WriteLn(':', darb_n.VDydis);
      VMazinkVienetu(darb_n);
      //VRasyk(darb_r);
      //WriteLn(':', darb_r.VDydis);
      VMazinkVienetu(darb_r);
      //VRasyk(darb_m);
      //WriteLn(':', darb_m.VDydis);
      VMazinkVienetu(darb_m);
    end;
    VNaik(knygos_n);
    VNaik(knygos_r);
    Naikinti_Medi(knygos_m);
    VNaik(darb_n);
    VNaik(darb_r);
    VNaik(darb_m);
  end;
procedure Pagrindine(var max_darb_n, max_darb_r, max_darb_m: longint);
var
  skait_at_tik, ar_yra_knyga: shortint;
  v: vect;

begin
  if ParamSkaitymas('param.txt', skait_at_tik, ar_yra_knyga, v) = 0 then
  begin
    Randomize;
    BeDublikatu(v);
    DarboDiena(skait_at_tik, ar_yra_knyga, v, max_darb_n, max_darb_r, max_darb_m);
    WriteLn(max_darb_n);
    WriteLn(max_darb_r);
    WriteLn(max_darb_m);
    VNaik(v);
    {while v.VDydis > 0 do
    begin
      VRasyk(v);
      WriteLn;
      VMazinkVienetu(v);
    VRasyk(v); WriteLn;}
  end;
end;

var
  darb_n, darb_r, darb_m,
    max_darb_n, max_darb_r, max_darb_m,
    suma_darb_n, suma_darb_r, suma_darb_m: longint;
  i: longint;
begin
   suma
end.
