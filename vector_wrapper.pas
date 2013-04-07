unit Vector_Wrapper;

interface

uses vektorius, DuomenuTipas;

type
  wvP = ^wrapped_vector;

  wrapped_vector = record
    pradzia: vektor;
    elem: vektor;
    dydis: longint;
  end;

procedure Kurk(vector: wvP);
function Ptk(vector: wvP): boolean;
procedure Prid(vector: wvP; Duom: duomenu_tipas);
procedure Rasyk(vector: wvP);
function ElemTies(vector: wvP; Nr: integer): duomenu_tipas;
procedure Naik(vector: wvP);
procedure NaikElem(vector: wvP; Nr: integer);
function Rask(vector: wvP; Duom: duomenu_tipas): integer;
procedure Iterpk(vector: wvp; Nr: integer; duom: duomenu_tipas);
procedure Keisk(vector: wvP; Nr: integer; duom: duomenu_tipas);
function ArSukurtas(vector: wvP): boolean;

implementation

procedure Kurk(vector: wvP);
var
  tmpPradzia, tmpElem: vektor;
  tmpDydis: longint;
begin
  tmpPradzia := pradzia;
  tmpElem := elem;
  tmpDydis := VDydis;

  pradzia := vector^.pradzia;
  elem := vector^.elem;
  VDydis := vector^.dydis;

  VKurk;

  vector^.pradzia:= pradzia;
  vector^.elem := elem;

  pradzia := tmpPradzia;
  elem := tmpElem;
  VDydis := tmpDydis;
end;

function ArSukurtas(vector: wvP): boolean;
var
  tmpPradzia, tmpElem: vektor;
  tmpDydis: longint;
begin
  tmpPradzia := pradzia;
  tmpElem := elem;
  tmpDydis := VDydis;

  pradzia := vector^.pradzia;
  elem := vector^.elem;
  VDydis := vector^.dydis;

  ArSukurtas := VArSukurtas;

  pradzia := tmpPradzia;
  elem := tmpElem;
  VDydis := tmpDydis;
end;

function ElemTies(vector: wvP; Nr: integer): duomenu_tipas;
var
  tmpPradzia, tmpElem: vektor;
  tmpDydis: longint;
begin
  tmpPradzia := pradzia;
  tmpElem := elem;
  tmpDydis := VDydis;

  pradzia := vector^.pradzia;
  elem := vector^.elem;
  VDydis := vector^.dydis;

  ElemTies := VElem(Nr);

  pradzia := tmpPradzia;
  elem := tmpElem;
  VDydis := tmpDydis;
end;

procedure Iterpk(vector: wvp; Nr: integer; duom: duomenu_tipas);
var
  tmpPradzia, tmpElem: vektor;
  tmpDydis: longint;
begin
  tmpPradzia := pradzia;
  tmpElem := elem;
  tmpDydis := VDydis;

  pradzia := vector^.pradzia;
  elem := vector^.elem;
  VDydis := vector^.dydis;

  VIterpk(Nr, Duom);

  vector^.pradzia:= pradzia;

  pradzia := tmpPradzia;
  elem := tmpElem;
  VDydis := tmpDydis;
end;

procedure Keisk(vector: wvP; Nr: integer; duom: duomenu_tipas);
var
  tmpPradzia, tmpElem: vektor;
  tmpDydis: longint;
begin
  tmpPradzia := pradzia;
  tmpElem := elem;
  tmpDydis := VDydis;

  pradzia := vector^.pradzia;
  elem := vector^.elem;
  VDydis := vector^.dydis;

  VKeisk(Nr, Duom);

  pradzia := tmpPradzia;
  elem := tmpElem;
  VDydis := tmpDydis;
end;

procedure Naik(vector: wvP);
var
  tmpPradzia, tmpElem: vektor;
  tmpDydis: longint;
begin
  tmpPradzia := pradzia;
  tmpElem := elem;
  tmpDydis := VDydis;

  pradzia := vector^.pradzia;
  elem := vector^.elem;
  VDydis := vector^.dydis;

  VNaik;

  vector^.pradzia:= pradzia;

  pradzia := tmpPradzia;
  elem := tmpElem;
  VDydis := tmpDydis;
end;

procedure NaikElem(vector: wvP; Nr: integer);
var
  tmpPradzia, tmpElem: vektor;
  tmpDydis: longint;
begin
  tmpPradzia := pradzia;
  tmpElem := elem;
  tmpDydis := VDydis;

  pradzia := vector^.pradzia;
  elem := vector^.elem;
  VDydis := vector^.dydis;

  VNaikElem(Nr);

  vector^.pradzia:= pradzia;

  pradzia := tmpPradzia;
  elem := tmpElem;
  VDydis := tmpDydis;
end;

procedure Prid(vector: wvP; Duom: duomenu_tipas);
var
  tmpPradzia, tmpElem: vektor;
  tmpDydis: longint;
begin
  tmpPradzia := pradzia;
  tmpElem := elem;
  tmpDydis := VDydis;

  pradzia := vector^.pradzia;
  elem := vector^.elem;
  VDydis := vector^.dydis;

  VPrid(Duom);

  vector^.elem := elem;

  pradzia := tmpPradzia;
  elem := tmpElem;
  VDydis := tmpDydis;
end;

function Ptk(vector: wvP): boolean;
var
  tmpPradzia, tmpElem: vektor;
  tmpDydis: longint;
begin
  tmpPradzia := pradzia;
  tmpElem := elem;
  tmpDydis := VDydis;

  pradzia := vector^.pradzia;
  elem := vector^.elem;
  VDydis := vector^.dydis;

  Ptk := VPtk;

  pradzia := tmpPradzia;
  elem := tmpElem;
  VDydis := tmpDydis;
end;

procedure Rasyk(vector: wvP);
var
  tmpPradzia, tmpElem: vektor;
  tmpDydis: longint;
begin
  tmpPradzia := pradzia;
  tmpElem := elem;
  tmpDydis := VDydis;

  pradzia := vector^.pradzia;
  elem := vector^.elem;
  VDydis := vector^.dydis;

  VRasyk;

  pradzia := tmpPradzia;
  elem := tmpElem;
  VDydis := tmpDydis;
end;

function Rask(vector: wvP; Duom: duomenu_tipas): integer;
var
  tmpPradzia, tmpElem: vektor;
  tmpDydis: longint;
begin
  tmpPradzia := pradzia;
  tmpElem := elem;
  tmpDydis := VDydis;

  pradzia := vector^.pradzia;
  elem := vector^.elem;
  VDydis := vector^.dydis;

  Rask := VRask(Duom);

  pradzia := tmpPradzia;
  elem := tmpElem;
  VDydis := tmpDydis;
end;

end.
