unit vektorius;

interface

uses DuomenuTipas;                                          //èia keièiamas vektoriuje saugomø duomenø tipas

type vektor=^Element;
     Element=record
                Kitas:^Element;
                Duomenys:duomenu_tipas;
             end;

     procedure VKurk;                                       //Sukuria tuðèia vektoriu                       VKurk;
     function VPtk:boolean;                                 //Patikrina ar vektorius tuscias                VPtk;
     procedure VPrid(Duom:duomenu_tipas);                   //Prideda elementà á vektoriaus galà            VPrid(Elementas);
     procedure VRasyk;                                      //Isveda visus vektoriaus elementus á ekranà    VRasyk;
     function VElem(Nr:integer):duomenu_tipas;              //Gauna n-tojo elemento duomenis.               VElem(n);
     procedure VNaik;                                       //Atlaisvina atmintá                            VNaik;
     procedure VNaikElem(Nr:integer);                       //Istrina n-tàjá elementà                       VNaikElem(n);
     function VRask(Duom:duomenu_tipas):integer;            //Randa elemento su dëmeniu S numerá            VRask(S);
     procedure VIterpk(Nr:integer; duom:duomenu_tipas);     //Iterpia elementà prieð n-tajá elementà        VIterpk(n,Elementas);
     procedure VKeisk(Nr:integer; duom:duomenu_tipas);      //Pakeièia n-tajá elementà, kitu elementu       VKeisk(n,Elementas);
     function VArSukurtas:boolean;                          //Patikrina ar sukurtas vektorius               VArSukurtas;  True - sukurtas False - nesukurtas
     
var elem,pradzia:vektor;
          VDydis:longint;                                   //Kintamasis kuriame saugomas vektoriaus elementû skaicius  VDydis;

implementation

procedure VKurk;
begin
  new(elem);
  pradzia:=elem;
  pradzia^.kitas:=nil;
  VDydis:=0;
end;

function VPtk:boolean;
begin
  VPtk:=(VDydis=0);
end;

procedure VPrid(Duom:duomenu_tipas);
begin
  If VDydis=0
   then begin
         Elem^.Duomenys:=Duom;
         Elem^.kitas:=nil;
         inc(VDydis);
        end
   else begin
         new(elem^.kitas);
         elem:=elem^.kitas;
         Elem^.Duomenys:=Duom;
         Elem^.kitas:=nil;
         inc(VDydis);
        end;
end;

procedure VRasyk;
  var E:vektor;
begin

  E:=pradzia;
  while E<>nil do
   begin
    write(E^.duomenys,' ');
    e:=e^.kitas;
   end;
end;

function VElem(Nr:integer):duomenu_tipas;
  var i:integer; E:vektor;
begin
  if Nr<1 then halt;
  E:=pradzia;
  for i:=1 to Nr-1 do E:=E^.kitas;
  VElem:=E^.duomenys;
end;

procedure VNaik;
  var tarpinis:vektor;
begin
  while pradzia^.kitas<>nil do
   begin
    tarpinis:=pradzia;
    pradzia:=pradzia^.kitas;
    dispose(tarpinis);
   end;
  dispose(pradzia);
  VDydis:=0;
end;

procedure VNaikElem(Nr:integer);
  var tarpinis,E:vektor; i:integer;
begin
  E:=pradzia;
  if Nr<1 then halt;
  if Nr=1 then  begin E:=Pradzia;
                      Pradzia:=Pradzia^.kitas;
                      Dispose(E);
                      dec(VDydis);
                end
          else  begin for i:=1 to Nr-2 do E:=E^.kitas;
                      tarpinis:=E^.kitas;
                      E^.kitas:=tarpinis^.kitas;
                      dispose(tarpinis);
                      Dec(VDydis);
                end;
end;

function VRask(Duom:duomenu_tipas):integer;
  var E:vektor; i:integer; Nerastas:boolean;
begin
  E:=pradzia;
  Nerastas:=True;
  i:=1;
  while e<>nil do
   begin
    if VElem(i)=duom then begin VRask:=i;
                                Nerastas:=False;
                                Break;
                          end;
    E:=E^.kitas;
    inc(i);
   end;
  if nerastas then VRask:=0;
end;

procedure VIterpk(Nr:integer; duom:duomenu_tipas);
  var E,tarpinis:vektor; i:integer;
begin
  E:=pradzia;
  if Nr<1 then halt;
  if Nr=1 then begin if pradzia=nil then halt;
  
                     new(tarpinis);
                     tarpinis^.kitas:=pradzia;
                     tarpinis^.duomenys:=duom;
                     pradzia:=tarpinis;
                     inc(VDydis);
               end
          else begin for i:=1 to Nr-2 do E:=E^.kitas;
                     new(tarpinis);
                     tarpinis^.kitas:=E^.kitas;
                     E^.kitas:=tarpinis;
                     tarpinis^.duomenys:=duom;
                     inc(VDydis);
               end;
end;


procedure VKeisk(Nr:integer; duom:duomenu_tipas);
var E,tarpinis:vektor; i:integer;
begin
  E:=pradzia;
  if Nr<1 then halt;
  for i:=1 to Nr-1 do E:=E^.kitas;
  E^.duomenys:=duom;
end;

function VArSukurtas:boolean;
begin
  if pradzia= nil then VArSukurtas:=False
                  else VArSukurtas:=True;
end;

end.
