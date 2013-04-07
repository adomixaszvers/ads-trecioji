unit Vector_Wrapper;

interface

uses vektorius, DuomenuTipas;

type
  wvP = ^wrapped_vector;
  wrapped_vector = record
    pradzia: vektorius.vektor;
    elem: vektorius.vektor;
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

end.
